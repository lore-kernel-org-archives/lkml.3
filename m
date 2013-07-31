Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516Ab3GaPvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:51:20 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:53264 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab3GaPvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:51:18 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-90-51f93274c1cb
From: Shuah Khan <shuah.kh@samsung.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [char-misc 3.11 V2] mei: me: fix hardware reset flow
Thread-topic: [char-misc 3.11 V2] mei: me: fix hardware reset flow
Thread-index: AQHOjRXfJ/5nZZSBIEm/1iKXnTSuJw==
Date: Wed, 31 Jul 2013 15:51:14 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6174F3DA@sisaex01sj>
References: <1375182711-10253-1-git-send-email-tomas.winkler@intel.com>
 <20130730142209.GA28956@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE783C8@HASMSX106.ger.corp.intel.com>
 <B8EFE96D1287C24090BAD9D858E15E6174EAFA@sisaex01sj>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE7868F@HASMSX106.ger.corp.intel.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+wn26J0c9Ag1MvrCz+TjrGbtG8eD2b
	xflbn5ktLu+aw2bxoafOgdXj969JjB6L97xk8tg/dw27x6TDn5k8Pm+SC2CN4rJJSc3JLEst
	0rdL4Mr41nyUreCcbEXf2XWsDYx3xbsYOTkkBEwk5u95wgJhi0lcuLeeDcQWEljGKLFjgQWE
	3cskcfqCXRcjF5A9n1Hi+pFp7CAJNgF1ic+vd4DZIgJ6ErdWz2EHKWIWeMAo8eLfNbCpwgKO
	EnfOXWSGKHKS2D/rKhNMw5s5kxhBbBYBVYmlM7aBDeIVsJdovXSBDWLbNiaJNZN+gTUwAp33
	/dQaMJtZQFyiufUm1NkCEkv2nGeGsEUlXj7+x9rFyAFkK0psX20FUa4lsX7ncahWbYkn7y6w
	QuwSlPgx+R7LBEaxWUimzkLSMgtJyywkLQsYWVYxipUWJxcUJ6WnVhjqFSfmFpfmpesl5+du
	YoTEXtUOxjtfbQ4xCnAwKvHwOlz4HijEmlhWXJl7iFGCg1lJhHcP689AId6UxMqq1KL8+KLS
	nNTiQ4xMHJxSDYx6T8LPHol5GfbnTFnr8p185Q1FduHfl2pL1EiWyLDVPHHdvf22z6rrKpaf
	4pZslNc01HnAtW1/ZuybIl8pw21z4z4eEVISTppbc3zjr+cyZt+eHD630+mbrPyNVf8E8liO
	v438GhsrsdrGSYvff83yuhVRxcsaXT5q23zbvbuys/BQ14V5r9YosRRnJBpqMRcVJwIA3UGo
	A5sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 01:30 PM, Winkler, Tomas wrote:
>
>>
>   >>> Both H_IS and H_IE needs to be set to receive H_RDY interrupt
>>>>>
>>>>> 1. Assert H_IS to clear the interrupts during hw reset and use
>>>>> mei_me_reg_write instead of mei_hcsr_set as the later strips down
>>>>> the H_IS
>>>>>
>>>>> 2. fix interrupt disablement embarrassing typo
>>>>>     hcsr |= ~H_IE -> hcsr &= ~H_IE;
>>>>> this will remove the unwanted interrupt on power down
>>>>>
>>>>> 3. remove useless debug print outs
>>>>>
>>>>> Cc: Shuah Khan <shuah.kh@samsung.com>
>>>>> Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
>>>>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>>>>> ---
>>>>>
>>>>> V2: Fixed typo in Shuah email
>>>>>
>>>>> Hope this finally resolve the ME reset issue for all
>>>>
>>>> Can I get a "Tested-by:" from someone to ensure that it really does
>>>> solve the problem?
>>>
>>> Yes,  please wait for ack/test results. It works for me but unfortunately I
>> cannot go over all  9 gens of  PCH and all their proliferations  where ME
>> resides.
>>> I'm putting some effort to have better legacy HW testing coverage but I'm
>> not there yet.
>>>
>>
>> Tomas,
>>
>> I have a test system that has shows the mei_me reset problem after boot-
>> up. I tested this patch on top of 3.11-rc3 that has the previous 4 patches. I am
>> seeing the issue still on this system:
>>
>> 00:03.0 Communication controller: Intel Corporation 82Q963/Q965 HECI
>> Controller (rev 02)
>>           Subsystem: Hewlett-Packard Company Device 2801
>>           Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>           Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>           Latency: 0
>>           Interrupt: pin A routed to IRQ 41
>>           Region 0: Memory at f0521900 (64-bit, non-prefetchable) [size=16]
>>           Capabilities: <access denied>
>>           Kernel driver in use: mei_me
>>
>>
>> I am attaching the dmesg. Please let me know if you need any more
>> information from the system.
>
> I'm not sure this error though looks similar is coming from the same source,  this is even after boot up, which  I haven't seen before.
> Would it be possible you open more logs through dynamic debug on mei and mei_me modules
> To preserve it over reboot I add it into /etc/modprobe.d/mei.conf
> options mei dyndbg="+plf"
> options mei_me dyndbg="+plf"
>
> Thanks
> Tomas
>

Tomas,

I tested the patch on the system I saw this problem during 
suspend/resume sequence. After 10 suspend-to-disk reboot mode and 10 
suspend-to-disk platform mode tests, I couldn't reproduce the problem. 
So does this mean the problem went away. I don't know. With all your 
fixes I no longer can reproduce the problem during suspend/resume 
sequence. I used to see once every 3 or 4 suspend-to-resume attempts on 
this system.

The second machine I have I see the problem often during run-time and 
that has nothing to do with suspend/resume. I will get the dyndbg data 
you asked for from that system.

You have my Tested-by for the original suspend/resume problem I reported.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
