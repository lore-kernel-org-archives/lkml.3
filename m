Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3EOGZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 02:25:39 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47340 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab3EOGZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 02:25:37 -0400
MIME-Version: 1.0
In-Reply-To: <51926325.2050805@wwwdotorg.org>
References: <7e12acada8adcba5f4eb72f6c49e38aaf00a294f.1368434974.git.viresh.kumar@linaro.org>
	<5191148E.7050205@wwwdotorg.org>
	<CAKohpo=MS6D9DGiZDUPPYA47c=tqWXUMC6bdssD5xL=7GEcDvw@mail.gmail.com>
	<51926325.2050805@wwwdotorg.org>
Date: Wed, 15 May 2013 11:55:36 +0530
Message-ID: <CAKohponZaka9MCfnHAq602oQ42+SR7D1oM6ggODHAzQy==Y4WQ@mail.gmail.com>
Subject: Re: [PATCH V1 resend] cpufreq: Raname index as data in cpufreq_frequency_table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Sekhar Nori <nsekhar@ti.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Olof Johansson <olof@lixom.net>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: multipart/mixed; boundary=089e013d07585d774604dcbbd131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013d07585d774604dcbbd131
Content-Type: text/plain; charset=ISO-8859-1

On 14 May 2013 21:45, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/14/2013 07:46 AM, Viresh Kumar wrote:
> ...
>> This must address your concerns:
>> @Rafael: I have attached both patches now for you to apply.
>>
>> From: Viresh Kumar <viresh.kumar@linaro.org>
>> Date: Tue, 14 May 2013 19:08:50 +0530
>> Subject: [PATCH 1/2] cpufreq: tegra: Remove irrelevant comment
>>
>> Tegra cpufreq driver doesn't use .index field of cpufreq_frequency_table and so
>> comment mentioning order of .index is irrelevant. Remove it.
>
>> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
>
>> -/* Frequency table index must be sequential starting at 0 */
>>  static struct cpufreq_frequency_table freq_table[] = {
>>       { 0, 216000 },
>>       { 1, 312000 },
>
> Does the .index/.data field even need to be filled in any more?

No. But i didn't wanted to write following code: { .frequency = *** }, as
earlier one was fine too.

Ack whichever version you want (Attached too):

-----------x-----------------x-----------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Tue, 14 May 2013 19:08:50 +0530
Subject: [PATCH] cpufreq: tegra: Don't initialize .index field of
 cpufreq_frequency_table

Tegra cpufreq driver doesn't use .index field of cpufreq_frequency_table and so
we don't need to initialize it. Don't initialize it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index c74c0e1..81561be 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -28,17 +28,16 @@
 #include <linux/io.h>
 #include <linux/suspend.h>

-/* Frequency table index must be sequential starting at 0 */
 static struct cpufreq_frequency_table freq_table[] = {
-	{ 0, 216000 },
-	{ 1, 312000 },
-	{ 2, 456000 },
-	{ 3, 608000 },
-	{ 4, 760000 },
-	{ 5, 816000 },
-	{ 6, 912000 },
-	{ 7, 1000000 },
-	{ 8, CPUFREQ_TABLE_END },
+	{ .frequency = 216000 },
+	{ .frequency = 312000 },
+	{ .frequency = 456000 },
+	{ .frequency = 608000 },
+	{ .frequency = 760000 },
+	{ .frequency = 816000 },
+	{ .frequency = 912000 },
+	{ .frequency = 1000000 },
+	{ .frequency = CPUFREQ_TABLE_END },
 };

 #define NUM_CPUS	2

--089e013d07585d774604dcbbd131
Content-Type: application/octet-stream; 
	name="0001-cpufreq-tegra-Don-t-initialize-.index-field-of-cpufr.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-tegra-Don-t-initialize-.index-field-of-cpufr.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hgq4kobx0

RnJvbSA0ZjUyMDY3ZTNiYjBmNDQ4ZDdhMzc5ZmYyNzFjNmY4MzBkNDk2YjM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NGY1MjA2N2UzYmIwZjQ0OGQ3YTM3OWZmMjcxYzZm
ODMwZDQ5NmIzOC4xMzY4NTk5MDMwLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogVHVlLCAxNCBNYXkg
MjAxMyAxOTowODo1MCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IHRlZ3JhOiBEb24n
dCBpbml0aWFsaXplIC5pbmRleCBmaWVsZCBvZgogY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGUKClRl
Z3JhIGNwdWZyZXEgZHJpdmVyIGRvZXNuJ3QgdXNlIC5pbmRleCBmaWVsZCBvZiBjcHVmcmVxX2Zy
ZXF1ZW5jeV90YWJsZSBhbmQgc28Kd2UgZG9uJ3QgbmVlZCB0byBpbml0aWFsaXplIGl0LiBEb24n
dCBpbml0aWFsaXplIGl0LgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3Vt
YXJAbGluYXJvLm9yZz4KLS0tCiBkcml2ZXJzL2NwdWZyZXEvdGVncmEtY3B1ZnJlcS5jIHwgMTkg
KysrKysrKysrLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMTAg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVmcmVxL3RlZ3JhLWNwdWZyZXEu
YyBiL2RyaXZlcnMvY3B1ZnJlcS90ZWdyYS1jcHVmcmVxLmMKaW5kZXggYzc0YzBlMS4uODE1NjFi
ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL3RlZ3JhLWNwdWZyZXEuYworKysgYi9kcml2
ZXJzL2NwdWZyZXEvdGVncmEtY3B1ZnJlcS5jCkBAIC0yOCwxNyArMjgsMTYgQEAKICNpbmNsdWRl
IDxsaW51eC9pby5oPgogI2luY2x1ZGUgPGxpbnV4L3N1c3BlbmQuaD4KIAotLyogRnJlcXVlbmN5
IHRhYmxlIGluZGV4IG11c3QgYmUgc2VxdWVudGlhbCBzdGFydGluZyBhdCAwICovCiBzdGF0aWMg
c3RydWN0IGNwdWZyZXFfZnJlcXVlbmN5X3RhYmxlIGZyZXFfdGFibGVbXSA9IHsKLQl7IDAsIDIx
NjAwMCB9LAotCXsgMSwgMzEyMDAwIH0sCi0JeyAyLCA0NTYwMDAgfSwKLQl7IDMsIDYwODAwMCB9
LAotCXsgNCwgNzYwMDAwIH0sCi0JeyA1LCA4MTYwMDAgfSwKLQl7IDYsIDkxMjAwMCB9LAotCXsg
NywgMTAwMDAwMCB9LAotCXsgOCwgQ1BVRlJFUV9UQUJMRV9FTkQgfSwKKwl7IC5mcmVxdWVuY3kg
PSAyMTYwMDAgfSwKKwl7IC5mcmVxdWVuY3kgPSAzMTIwMDAgfSwKKwl7IC5mcmVxdWVuY3kgPSA0
NTYwMDAgfSwKKwl7IC5mcmVxdWVuY3kgPSA2MDgwMDAgfSwKKwl7IC5mcmVxdWVuY3kgPSA3NjAw
MDAgfSwKKwl7IC5mcmVxdWVuY3kgPSA4MTYwMDAgfSwKKwl7IC5mcmVxdWVuY3kgPSA5MTIwMDAg
fSwKKwl7IC5mcmVxdWVuY3kgPSAxMDAwMDAwIH0sCisJeyAuZnJlcXVlbmN5ID0gQ1BVRlJFUV9U
QUJMRV9FTkQgfSwKIH07CiAKICNkZWZpbmUgTlVNX0NQVVMJMgotLSAKMS43LjEyLnJjMi4xOC5n
NjFiNDcyZQoK
--089e013d07585d774604dcbbd131--
