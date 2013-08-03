Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3HCN1O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 09:27:14 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:37653 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3HCN1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 09:27:12 -0400
MIME-Version: 1.0
In-Reply-To: <4846602.3FgvAM66Ta@vostro.rjw.lan>
References: <cover.1375530162.git.viresh.kumar@linaro.org>
	<46faea4c060f91f7102d9d33c816693acc25a917.1375530162.git.viresh.kumar@linaro.org>
	<4846602.3FgvAM66Ta@vostro.rjw.lan>
Date: Sat, 3 Aug 2013 18:57:11 +0530
Message-ID: <CAKohpokdWMjeZ=GKt4SaJDaA4Dn-WODpE_Mn+VEBpxB=VNAuyw@mail.gmail.com>
Subject: Re: [PATCH 08/10] cpufreq: Fix broken usage of governor->owner's refcount
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        l.majewski@samsung.com
Content-Type: multipart/mixed; boundary=001a11c31ca2639a1704e30b0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c31ca2639a1704e30b0800
Content-Type: text/plain; charset=ISO-8859-1

On 3 August 2013 17:38, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, August 03, 2013 05:19:26 PM Viresh Kumar wrote:
>> Governor's owner refcount usage was broken. We should increment refcount only
>> when CPUFREQ_GOV_POLICY_INIT event has come and should decrement only if
>> CPUFREQ_GOV_POLICY_EXIT has come.
>>
>> Lets fix it.
>
> OK, and what happens if we don't fix it?

What about this changelog:

Subject: [PATCH 08/10] cpufreq: Fix broken usage of governor->owner's
 refcount

Governor's owner refcount usage was broken. We should increment refcount only
when CPUFREQ_GOV_POLICY_INIT event has come and should decrement only if
CPUFREQ_GOV_POLICY_EXIT has come.

Currently there can be situations where governor is in use but we have allowed
it to be unloaded. And that may cause in undefined behavior.

Lets fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

--001a11c31ca2639a1704e30b0800
Content-Type: application/octet-stream; 
	name="0008-cpufreq-Fix-broken-usage-of-governor-owner-s-refcoun.patch"
Content-Disposition: attachment; 
	filename="0008-cpufreq-Fix-broken-usage-of-governor-owner-s-refcoun.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjwuvgcr0

RnJvbSA0NmZhZWE0YzA2MGY5MWY3MTAyZDlkMzNjODE2NjkzYWNjMjVhOTE3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NDZmYWVhNGMwNjBmOTFmNzEwMmQ5ZDMzYzgxNjY5
M2FjYzI1YTkxNy4xMzc1NTM2MjAxLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KSW4tUmVw
bHktVG86IDxmZTY3ZjMyNjlhMDcxMjNiMDI1NDY4MjE0ZTY5MmFmNTczYjA3MzY0LjEzNzU1MzYy
MDAuZ2l0LnZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgpSZWZlcmVuY2VzOiA8ZmU2N2YzMjY5YTA3
MTIzYjAyNTQ2ODIxNGU2OTJhZjU3M2IwNzM2NC4xMzc1NTM2MjAwLmdpdC52aXJlc2gua3VtYXJA
bGluYXJvLm9yZz4KRnJvbTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4K
RGF0ZTogU2F0LCAzIEF1ZyAyMDEzIDE1OjUzOjMyICswNTMwClN1YmplY3Q6IFtQQVRDSCAwOC8x
MF0gY3B1ZnJlcTogRml4IGJyb2tlbiB1c2FnZSBvZiBnb3Zlcm5vci0+b3duZXIncwogcmVmY291
bnQKCkdvdmVybm9yJ3Mgb3duZXIgcmVmY291bnQgdXNhZ2Ugd2FzIGJyb2tlbi4gV2Ugc2hvdWxk
IGluY3JlbWVudCByZWZjb3VudCBvbmx5CndoZW4gQ1BVRlJFUV9HT1ZfUE9MSUNZX0lOSVQgZXZl
bnQgaGFzIGNvbWUgYW5kIHNob3VsZCBkZWNyZW1lbnQgb25seSBpZgpDUFVGUkVRX0dPVl9QT0xJ
Q1lfRVhJVCBoYXMgY29tZS4KCkN1cnJlbnRseSB0aGVyZSBjYW4gYmUgc2l0dWF0aW9ucyB3aGVy
ZSBnb3Zlcm5vciBpcyBpbiB1c2UgYnV0IHdlIGhhdmUgYWxsb3dlZAppdCB0byBiZSB1bmxvYWRl
ZC4gQW5kIHRoYXQgbWF5IGNhdXNlIGluIHVuZGVmaW5lZCBiZWhhdmlvci4KCkxldHMgZml4IGl0
LgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4K
LS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIHwgMTQgKysrKysrKy0tLS0tLS0KIDEgZmls
ZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKaW5k
ZXggZTliOTY5Zi4uNzRkNDk2OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEu
YworKysgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCkBAIC0xNzA3LDggKzE3MDcsOSBAQCBz
dGF0aWMgaW50IF9fY3B1ZnJlcV9nb3Zlcm5vcihzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGlj
eSwKIAkJfQogCX0KIAotCWlmICghdHJ5X21vZHVsZV9nZXQocG9saWN5LT5nb3Zlcm5vci0+b3du
ZXIpKQotCQlyZXR1cm4gLUVJTlZBTDsKKwlpZiAoZXZlbnQgPT0gQ1BVRlJFUV9HT1ZfUE9MSUNZ
X0lOSVQpCisJCWlmICghdHJ5X21vZHVsZV9nZXQocG9saWN5LT5nb3Zlcm5vci0+b3duZXIpKQor
CQkJcmV0dXJuIC1FSU5WQUw7CiAKIAlwcl9kZWJ1ZygiX19jcHVmcmVxX2dvdmVybm9yIGZvciBD
UFUgJXUsIGV2ZW50ICV1XG4iLAogCQkJCQkJcG9saWN5LT5jcHUsIGV2ZW50KTsKQEAgLTE3MTcs
NiArMTcxOCw4IEBAIHN0YXRpYyBpbnQgX19jcHVmcmVxX2dvdmVybm9yKHN0cnVjdCBjcHVmcmVx
X3BvbGljeSAqcG9saWN5LAogCWlmICgoIXBvbGljeS0+Z292ZXJub3JfZW5hYmxlZCAmJiAoZXZl
bnQgPT0gQ1BVRlJFUV9HT1ZfU1RPUCkpIHx8CiAJICAgIChwb2xpY3ktPmdvdmVybm9yX2VuYWJs
ZWQgJiYgKGV2ZW50ID09IENQVUZSRVFfR09WX1NUQVJUKSkpIHsKIAkJbXV0ZXhfdW5sb2NrKCZj
cHVmcmVxX2dvdmVybm9yX2xvY2spOworCQlpZiAoZXZlbnQgPT0gQ1BVRlJFUV9HT1ZfUE9MSUNZ
X0lOSVQpCisJCQltb2R1bGVfcHV0KHBvbGljeS0+Z292ZXJub3ItPm93bmVyKTsKIAkJcmV0dXJu
IC1FQlVTWTsKIAl9CiAKQEAgLTE3NDQsMTEgKzE3NDcsOCBAQCBzdGF0aWMgaW50IF9fY3B1ZnJl
cV9nb3Zlcm5vcihzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAkJbXV0ZXhfdW5sb2Nr
KCZjcHVmcmVxX2dvdmVybm9yX2xvY2spOwogCX0KIAotCS8qIHdlIGtlZXAgb25lIG1vZHVsZSBy
ZWZlcmVuY2UgYWxpdmUgZm9yCi0JCQllYWNoIENQVSBnb3Zlcm5lZCBieSB0aGlzIENQVSAqLwot
CWlmICgoZXZlbnQgIT0gQ1BVRlJFUV9HT1ZfU1RBUlQpIHx8IHJldCkKLQkJbW9kdWxlX3B1dChw
b2xpY3ktPmdvdmVybm9yLT5vd25lcik7Ci0JaWYgKChldmVudCA9PSBDUFVGUkVRX0dPVl9TVE9Q
KSAmJiAhcmV0KQorCWlmICgoKGV2ZW50ID09IENQVUZSRVFfR09WX1BPTElDWV9JTklUKSAmJiBy
ZXQpIHx8CisJCQkoKGV2ZW50ID09IENQVUZSRVFfR09WX1BPTElDWV9FWElUKSAmJiAhcmV0KSkK
IAkJbW9kdWxlX3B1dChwb2xpY3ktPmdvdmVybm9yLT5vd25lcik7CiAKIAlyZXR1cm4gcmV0Owot
LSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--001a11c31ca2639a1704e30b0800--
