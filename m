Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab3FXNcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:32:03 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:43863 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3FXNcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:32:00 -0400
MIME-Version: 1.0
In-Reply-To: <2165396.dF1lQyPRVT@vostro.rjw.lan>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
	<11846442.bozySFIXTh@vostro.rjw.lan>
	<CAKohponQQphBGv9jUCF9_r2NQs7T=wkaWp_d5oO3RT=mY_zqcg@mail.gmail.com>
	<2165396.dF1lQyPRVT@vostro.rjw.lan>
Date: Mon, 24 Jun 2013 19:01:59 +0530
Message-ID: <CAKohponyMG-uA93ZpH-KD+EOQPmk5tT_QoaQ7+NCEf48vYj5-w@mail.gmail.com>
Subject: Re: [PATCH 13/13] cpufreq: make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Content-Type: multipart/mixed; boundary=e89a8ff25454ea0bf704dfe66fe4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8ff25454ea0bf704dfe66fe4
Content-Type: text/plain; charset=ISO-8859-1

On 24 June 2013 19:03, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Looks OK, but since transition_ongoing is either 0 or 1 now, as far as I can
> say, it would be better to make it a bool and use = true/false instead of
> ++/-- I suppose.

Another fixup:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6ca7eac..49d942a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -108,7 +108,7 @@ static BLOCKING_NOTIFIER_HEAD(cpufreq_policy_notifier_list);
 static struct srcu_notifier_head cpufreq_transition_notifier_list;

 /* Tracks status of transition */
-static int transition_ongoing;
+static bool transition_ongoing;

 static bool init_cpufreq_transition_notifier_list_called;
 static int __init init_cpufreq_transition_notifier_list(void)
@@ -271,7 +271,7 @@ void __cpufreq_notify_transition(struct
cpufreq_policy *policy,
                                "In middle of another frequency transition\n"))
                        return;

-               transition_ongoing++;
+               transition_ongoing = true;

                /* detect if the driver reported a value as "old frequency"
                 * which is not equal to what the cpufreq core thinks is
@@ -296,7 +296,7 @@ void __cpufreq_notify_transition(struct
cpufreq_policy *policy,
                                "No frequency transition in progress\n"))
                        return;

-               transition_ongoing--;
+               transition_ongoing = false;

                adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
                pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,

--e89a8ff25454ea0bf704dfe66fe4
Content-Type: application/octet-stream; 
	name="0001-cpufreq-make-sure-frequency-transitions-are-serializ.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-make-sure-frequency-transitions-are-serializ.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hibpfjk90

RnJvbSBiOGMzYmQ5ZmNiNTIxZjFiNjZkNTJmMTU3ZmMyNmVjY2Y2Y2M0ZjI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8YjhjM2JkOWZjYjUyMWYxYjY2ZDUyZjE1N2ZjMjZl
Y2NmNmNjNGYyOS4xMzcyMDgwNjU2LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogV2VkLCAxOSBKdW4g
MjAxMyAxMDoxNjo1NSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IG1ha2Ugc3VyZSBm
cmVxdWVuY3kgdHJhbnNpdGlvbnMgYXJlIHNlcmlhbGl6ZWQKCldoZW5ldmVyIHdlIGFyZSBjaGFu
Z2luZyBmcmVxdWVuY3kgb2YgYSBjcHUsIHdlIGFyZSBjYWxsaW5nIFBSRUNIQU5HRSBhbmQKUE9T
VENIQU5HRSBub3RpZmllcnMuIFRoZXkgbXVzdCBiZSBzZXJpYWxpemVkLiBpLmUuIFBSRUNIQU5H
RSBvciBQT1NUQ0hBTkdFCnNob3VsZG4ndCBiZSBjYWxsZWQgdHdpY2UgY29udGlndW91c2x5LgoK
VGhpcyBjYW4gaGFwcGVuIGR1ZSB0byBidWdzIGluIHVzZXJzIG9mIF9fY3B1ZnJlcV9kcml2ZXJf
dGFyZ2V0KCkgb3IgYWN0dWFsCmNwdWZyZXEgZHJpdmVycyB3aG8gYXJlIHNlbmRpbmcgdGhlc2Ug
bm90aWZpZXJzLgoKVGhpcyBwYXRjaCBhZGRzIHNvbWUgcHJvdGVjdGlvbiBhZ2FpbnN0IHRoaXMu
IE5vdywgd2Uga2VlcCB0cmFjayBvZiB0aGUgbGFzdAp0cmFuc2FjdGlvbiBhbmQgc2VlIGlmIHNv
bWV0aGluZyB3ZW50IHdyb25nLgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gu
a3VtYXJAbGluYXJvLm9yZz4KLS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIHwgMTcgKysr
KysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVx
LmMKaW5kZXggMmQ1M2Y0Ny4uNDlkOTQyYSAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL2Nw
dWZyZXEuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCkBAIC0xMDcsNiArMTA3LDkg
QEAgc3RhdGljIHZvaWQgaGFuZGxlX3VwZGF0ZShzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwog
c3RhdGljIEJMT0NLSU5HX05PVElGSUVSX0hFQUQoY3B1ZnJlcV9wb2xpY3lfbm90aWZpZXJfbGlz
dCk7CiBzdGF0aWMgc3RydWN0IHNyY3Vfbm90aWZpZXJfaGVhZCBjcHVmcmVxX3RyYW5zaXRpb25f
bm90aWZpZXJfbGlzdDsKIAorLyogVHJhY2tzIHN0YXR1cyBvZiB0cmFuc2l0aW9uICovCitzdGF0
aWMgYm9vbCB0cmFuc2l0aW9uX29uZ29pbmc7CisKIHN0YXRpYyBib29sIGluaXRfY3B1ZnJlcV90
cmFuc2l0aW9uX25vdGlmaWVyX2xpc3RfY2FsbGVkOwogc3RhdGljIGludCBfX2luaXQgaW5pdF9j
cHVmcmVxX3RyYW5zaXRpb25fbm90aWZpZXJfbGlzdCh2b2lkKQogewpAQCAtMjY0LDYgKzI2Nywx
MiBAQCB2b2lkIF9fY3B1ZnJlcV9ub3RpZnlfdHJhbnNpdGlvbihzdHJ1Y3QgY3B1ZnJlcV9wb2xp
Y3kgKnBvbGljeSwKIAlzd2l0Y2ggKHN0YXRlKSB7CiAKIAljYXNlIENQVUZSRVFfUFJFQ0hBTkdF
OgorCQlpZiAoV0FSTih0cmFuc2l0aW9uX29uZ29pbmcsCisJCQkJIkluIG1pZGRsZSBvZiBhbm90
aGVyIGZyZXF1ZW5jeSB0cmFuc2l0aW9uXG4iKSkKKwkJCXJldHVybjsKKworCQl0cmFuc2l0aW9u
X29uZ29pbmcgPSB0cnVlOworCiAJCS8qIGRldGVjdCBpZiB0aGUgZHJpdmVyIHJlcG9ydGVkIGEg
dmFsdWUgYXMgIm9sZCBmcmVxdWVuY3kiCiAJCSAqIHdoaWNoIGlzIG5vdCBlcXVhbCB0byB3aGF0
IHRoZSBjcHVmcmVxIGNvcmUgdGhpbmtzIGlzCiAJCSAqICJvbGQgZnJlcXVlbmN5Ii4KQEAgLTI4
Myw2ICsyOTIsMTIgQEAgdm9pZCBfX2NwdWZyZXFfbm90aWZ5X3RyYW5zaXRpb24oc3RydWN0IGNw
dWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJCWJyZWFrOwogCiAJY2FzZSBDUFVGUkVRX1BPU1RDSEFO
R0U6CisJCWlmIChXQVJOKCF0cmFuc2l0aW9uX29uZ29pbmcsCisJCQkJIk5vIGZyZXF1ZW5jeSB0
cmFuc2l0aW9uIGluIHByb2dyZXNzXG4iKSkKKwkJCXJldHVybjsKKworCQl0cmFuc2l0aW9uX29u
Z29pbmcgPSBmYWxzZTsKKwogCQlhZGp1c3RfamlmZmllcyhDUFVGUkVRX1BPU1RDSEFOR0UsIGZy
ZXFzKTsKIAkJcHJfZGVidWcoIkZSRVE6ICVsdSAtIENQVTogJWx1IiwgKHVuc2lnbmVkIGxvbmcp
ZnJlcXMtPm5ldywKIAkJCSh1bnNpZ25lZCBsb25nKWZyZXFzLT5jcHUpOwpAQCAtMTQ1OCw2ICsx
NDczLDggQEAgaW50IF9fY3B1ZnJlcV9kcml2ZXJfdGFyZ2V0KHN0cnVjdCBjcHVmcmVxX3BvbGlj
eSAqcG9saWN5LAogCiAJaWYgKGNwdWZyZXFfZGlzYWJsZWQoKSkKIAkJcmV0dXJuIC1FTk9ERVY7
CisJaWYgKHRyYW5zaXRpb25fb25nb2luZykKKwkJcmV0dXJuIC1FQlVTWTsKIAogCS8qIE1ha2Ug
c3VyZSB0aGF0IHRhcmdldF9mcmVxIGlzIHdpdGhpbiBzdXBwb3J0ZWQgcmFuZ2UgKi8KIAlpZiAo
dGFyZ2V0X2ZyZXEgPiBwb2xpY3ktPm1heCkKLS0gCjEuNy4xMi5yYzIuMTguZzYxYjQ3MmUKCg==
--e89a8ff25454ea0bf704dfe66fe4--
