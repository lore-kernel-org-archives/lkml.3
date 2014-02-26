Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaBZCVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:21:25 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45692 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaBZCVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:21:24 -0500
Message-ID: <530D4F9E.70704@jp.fujitsu.com>
Date: Tue, 25 Feb 2014 21:21:18 -0500
From: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
CC: muneda.takahiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktest: Set CLOSE_CONSOLE_SIGNAL in the kvm.conf
References: <8738jatylb.wl%satoru.takeuchi@gmail.com> <20140224093039.6509b6cd@gandalf.local.home>
In-Reply-To: <20140224093039.6509b6cd@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-TM-AS-Product-Ver: IMSS-7.1.0.1403-7.5.0.1017-20532.002
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-MatchedRID: mZljRXDwq+6xiVrMUp+cq5paQZrxtVBsWyQijpt1UQkNcckEPxfz2Iu3
	renu5Y0wfmDk9kX3dCi7oJuTuWMpPtjTzYyhzXBGA9lly13c/gEHY/HQ9acau/gnJH5vm2+gyQ2
	GIx+U1Ru5vvrLcdgiU5urMMf0bt5MDjVNhrRWL76j87+S1NQ9t5sAVGimIUEKDO+DX+rUwfb/eb
	8DG9xHUQNMMYzMnKk5rotBFWSuK2hNfs8n85Te8hM0JxSxHjFJHpSfU35Tjw0E4g5QJth5ZHQdJ
	7XfU86ekGUtrowrXLg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 09:30:39 -0500,
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sun, 23 Feb 2014 10:19:28 +0900
> Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:
>
>> From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
>>
>> As mentioned at commit 5a5d8e48449, we can't terminate 'virsh console'
>> with the default signal(INT). So it's better to set CLOSE_CONSOLE_SIGNAL
>> in the kvm.conf.
>>
>> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>   tools/testing/ktest/examples/kvm.conf | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/tools/testing/ktest/examples/kvm.conf b/tools/testing/ktest/examples/kvm.conf
>> index 831c7c5..40356f7 100644
>> --- a/tools/testing/ktest/examples/kvm.conf
>> +++ b/tools/testing/ktest/examples/kvm.conf
>> @@ -10,6 +10,10 @@ MACHINE = Guest
>>   # Use virsh to read the serial console of the guest
>>   CONSOLE =  virsh console ${MACHINE}
>>
>> +# Use SIGILL to terminate virsh console. We can't kill virsh console
>> +# by the default signal, SIGINT.
>> +CLOSE_CONSOLE_SIGNAL = KILL
>> +
>
> Thanks, I'll add this to my 3.15 queue.

Hmm, it seems that we need a following patch as well.
Or, please merge with the orignal patch.

Thanks,
Takahiro

======================================================================
 From a1c7b948c47a6ea7b74225bf5698fdfb7199726a Mon Sep 17 00:00:00 2001
From: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
Date: Tue, 25 Feb 2014 15:32:35 -0500
Subject: [PATCH] ktest: Fixes a trivial typo

Signed-off-by: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>

---
  tools/testing/ktest/examples/kvm.conf | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/examples/kvm.conf b/tools/testing/ktest/examples/kvm.conf
index 40356f7..fbc134f 100644
--- a/tools/testing/ktest/examples/kvm.conf
+++ b/tools/testing/ktest/examples/kvm.conf
@@ -10,7 +10,7 @@ MACHINE = Guest
  # Use virsh to read the serial console of the guest
  CONSOLE =  virsh console ${MACHINE}
  
-# Use SIGILL to terminate virsh console. We can't kill virsh console
+# Use SIGKILL to terminate virsh console. We can't kill virsh console
  # by the default signal, SIGINT.
  CLOSE_CONSOLE_SIGNAL = KILL
  
-- 
1.8.3.1
