Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3JLP2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 11:28:14 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:44028 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3JLP2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 11:28:12 -0400
MIME-Version: 1.0
In-Reply-To: <1922770.iubCDBg3Zg@vostro.rjw.lan>
References: <6334c0aed4840857944d1b267871ada4d7014d57.1381541632.git.viresh.kumar@linaro.org>
	<1922770.iubCDBg3Zg@vostro.rjw.lan>
Date: Sat, 12 Oct 2013 20:58:10 +0530
Message-ID: <CAKohpokJkcsNN_vnQOuu2=arsiQCGPaCxpRL_TRAQYFg+LmR+w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: acpi: Add comment under ACPI_ADR_SPACE_SYSTEM_IO case
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b5dbfc8f7642d04e88ce1f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b5dbfc8f7642d04e88ce1f0
Content-Type: text/plain; charset=ISO-8859-1

On 12/10/2013, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Well, please merge it with the existing comment and use the usual format
> for comments that are longer than two lines.

I thought these are separate comments and so keeping them separate
might be better, so that this one doesn't get deleted in case somebody
is removing the other one.. and vice versa..

Anyway its fixed in attached commit now :)

commit ecb9ef81b50eb5e8559f7d132ef46803c8272091
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Sat Oct 12 07:00:01 2013 +0530

    cpufreq: acpi: Add comment under ACPI_ADR_SPACE_SYSTEM_IO case

    policy->cur is now set by cpufreq core when cpufreq_driver->get()
is defined and
    so drivers aren't required to set it. When space_id is
ACPI_ADR_SPACE_SYSTEM_IO
    for acpi cpufreq driver it doesn't set ->get to a valid function
pointer and so
    policy->cur is required to be set by driver.

    This is already followed in acpi-cpufreq driver. This patch adds a comment
    describing why we need to set policy->cur from driver.

    Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index a8dac7b..d2df543 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -837,7 +837,12 @@ static int acpi_cpufreq_cpu_init(struct
cpufreq_policy *policy)

        switch (perf->control_register.space_id) {
        case ACPI_ADR_SPACE_SYSTEM_IO:
-               /* Current speed is unknown and not detectable by IO port */
+               /*
+                * Current speed is unknown and not detectable by IO port.
+                * policy->cur wouldn't be set by core as cpufreq_driver->get()
+                * is NULL for this space_id and so we need to set policy->cur
+                * here.
+                */
                policy->cur = acpi_cpufreq_guess_freq(data, policy->cpu);
                break;
        case ACPI_ADR_SPACE_FIXED_HARDWARE:

--047d7b5dbfc8f7642d04e88ce1f0
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-cpufreq-acpi-Add-comment-under-ACPI_ADR_SPACE_SYSTEM.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-acpi-Add-comment-under-ACPI_ADR_SPACE_SYSTEM.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSBlY2I5ZWY4MWI1MGViNWU4NTU5ZjdkMTMyZWY0NjgwM2M4MjcyMDkxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZWNiOWVmODFiNTBlYjVlODU1OWY3ZDEzMmVmNDY4
MDNjODI3MjA5MS4xMzgxNTkxNDI5LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogU2F0LCAxMiBPY3Qg
MjAxMyAwNzowMDowMSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IGFjcGk6IEFkZCBj
b21tZW50IHVuZGVyIEFDUElfQURSX1NQQUNFX1NZU1RFTV9JTwogY2FzZQoKcG9saWN5LT5jdXIg
aXMgbm93IHNldCBieSBjcHVmcmVxIGNvcmUgd2hlbiBjcHVmcmVxX2RyaXZlci0+Z2V0KCkgaXMg
ZGVmaW5lZCBhbmQKc28gZHJpdmVycyBhcmVuJ3QgcmVxdWlyZWQgdG8gc2V0IGl0LiBXaGVuIHNw
YWNlX2lkIGlzIEFDUElfQURSX1NQQUNFX1NZU1RFTV9JTwpmb3IgYWNwaSBjcHVmcmVxIGRyaXZl
ciBpdCBkb2Vzbid0IHNldCAtPmdldCB0byBhIHZhbGlkIGZ1bmN0aW9uIHBvaW50ZXIgYW5kIHNv
CnBvbGljeS0+Y3VyIGlzIHJlcXVpcmVkIHRvIGJlIHNldCBieSBkcml2ZXIuCgpUaGlzIGlzIGFs
cmVhZHkgZm9sbG93ZWQgaW4gYWNwaS1jcHVmcmVxIGRyaXZlci4gVGhpcyBwYXRjaCBhZGRzIGEg
Y29tbWVudApkZXNjcmliaW5nIHdoeSB3ZSBuZWVkIHRvIHNldCBwb2xpY3ktPmN1ciBmcm9tIGRy
aXZlci4KClN1Z2dlc3RlZC1ieTogUmFmYWVsIEouIFd5c29ja2kgPHJhZmFlbC5qLnd5c29ja2lA
aW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBsaW5h
cm8ub3JnPgotLS0KIGRyaXZlcnMvY3B1ZnJlcS9hY3BpLWNwdWZyZXEuYyB8IDcgKysrKysrLQog
MSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvY3B1ZnJlcS9hY3BpLWNwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9hY3Bp
LWNwdWZyZXEuYwppbmRleCBhOGRhYzdiLi5kMmRmNTQzIDEwMDY0NAotLS0gYS9kcml2ZXJzL2Nw
dWZyZXEvYWNwaS1jcHVmcmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2FjcGktY3B1ZnJlcS5j
CkBAIC04MzcsNyArODM3LDEyIEBAIHN0YXRpYyBpbnQgYWNwaV9jcHVmcmVxX2NwdV9pbml0KHN0
cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5KQogCiAJc3dpdGNoIChwZXJmLT5jb250cm9sX3Jl
Z2lzdGVyLnNwYWNlX2lkKSB7CiAJY2FzZSBBQ1BJX0FEUl9TUEFDRV9TWVNURU1fSU86Ci0JCS8q
IEN1cnJlbnQgc3BlZWQgaXMgdW5rbm93biBhbmQgbm90IGRldGVjdGFibGUgYnkgSU8gcG9ydCAq
LworCQkvKgorCQkgKiBDdXJyZW50IHNwZWVkIGlzIHVua25vd24gYW5kIG5vdCBkZXRlY3RhYmxl
IGJ5IElPIHBvcnQuCisJCSAqIHBvbGljeS0+Y3VyIHdvdWxkbid0IGJlIHNldCBieSBjb3JlIGFz
IGNwdWZyZXFfZHJpdmVyLT5nZXQoKQorCQkgKiBpcyBOVUxMIGZvciB0aGlzIHNwYWNlX2lkIGFu
ZCBzbyB3ZSBuZWVkIHRvIHNldCBwb2xpY3ktPmN1cgorCQkgKiBoZXJlLgorCQkgKi8KIAkJcG9s
aWN5LT5jdXIgPSBhY3BpX2NwdWZyZXFfZ3Vlc3NfZnJlcShkYXRhLCBwb2xpY3ktPmNwdSk7CiAJ
CWJyZWFrOwogCWNhc2UgQUNQSV9BRFJfU1BBQ0VfRklYRURfSEFSRFdBUkU6Ci0tIAoxLjcuMTIu
cmMyLjE4Lmc2MWI0NzJlCgo=
--047d7b5dbfc8f7642d04e88ce1f0--
