Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3AJXPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:15:35 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45538 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3AJXPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:15:33 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
References: <CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
	<8762382z2c.fsf@xmission.com>
	<CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
	<87y5g4z7rp.fsf@xmission.com>
	<CAE9FiQVVtfxZs7E9Q=VbNHNbYJg_9TGCTetkZMYT0tgt0JLNZw@mail.gmail.com>
	<CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
	<20130109004340.GA12234@konrad-lan.dumpdata.com>
	<87txqruq8p.fsf@xmission.com>
	<CAE9FiQVgMK=CK5BvfOkGF3Pp4kOqBEg2mxX2zDuhW8zZXSVXzg@mail.gmail.com>
	<CAE9FiQVomDtc0P9B7aTDBrm7kC+i=GYokBmT54w-VBwZsafb5g@mail.gmail.com>
	<20130109132409.GB18395@phenom.dumpdata.com>
	<CAE9FiQUznCR6i56AW6jhiCCK-pQxnAquzxUoWWQamoSC8YAZKA@mail.gmail.com>
	<87d2xeul5v.fsf@xmission.com>
	<CAE9FiQX-OxTzt3BPh3nSLQxDUBGR=eKob5AqXYzy=Lw9NYTaGw@mail.gmail.com>
	<CAE9FiQVsbDfLOyv=D4_BLtrKpp+Ydj7pren8Cu3rNGztbj=w=w@mail.gmail.com>
Date: Thu, 10 Jan 2013 15:15:19 -0800
In-Reply-To: <CAE9FiQVsbDfLOyv=D4_BLtrKpp+Ydj7pren8Cu3rNGztbj=w=w@mail.gmail.com>
	(Yinghai Lu's message of "Thu, 10 Jan 2013 15:07:10 -0800")
Message-ID: <87sj68tyt4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19TnznwUUTk/qXPlOD6SHK/vFCWKuy8n8A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.9 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Yinghai Lu <yinghai@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not enough ram for it
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Wed, Jan 9, 2013 at 1:15 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Wed, Jan 9, 2013 at 1:00 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> Yinghai Lu <yinghai@kernel.org> writes:
>>>
>>>> please check updated attached. It should address all your request.
>>>
>>> There is one significant bug that I can see.
>>>
>>> swiotlb_print_info tests no_iotlb_memory but no_iotlb_memory is set
>>> after swiotlb_init_with_tlb returns.
>>
>> there is another swiotlb_print_info calling from
>> pci_swiotlb_late_init
>>
>> void __init pci_swiotlb_late_init(void)
>> {
>>         /* An IOMMU turned us off. */
>>         if (!swiotlb)
>>                 swiotlb_free();
>>         else {
>>                 printk(KERN_INFO "PCI-DMA: "
>>                        "Using software bounce buffering for IO (SWIOTLB)\n");
>>                 swiotlb_print_info();
>>         }
>> }
>>
>> so we need that checking when swiotlb == 1, but actually we can not
>> allocate that before.
>
> Eric, so the code is right to put checking in swiotlb_print_info ?

My biggest question was really why you didn't set no_iotlb
sooner.  But shrug I didn't see any real issue with the code except
for it being silly.

Certainly since we are calling swiotlb_print_info from outside swiotlb.c
the check is needed.

> I'd like to post the whole patchset again and ask HPA to put them in tip/next
> to catch -v3.9 merging window.

Eric
