Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaBBWZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 17:25:39 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:47455 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaBBWZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 17:25:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Pearson\, Greg" <greg.pearson@hp.com>,
        "vgoyal\@redhat.com" <vgoyal@redhat.com>,
        "d.hatayama\@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "holzheu\@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
        "dhowells\@redhat.com" <dhowells@redhat.com>,
        "paul.gortmaker\@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1391209566-4734-1-git-send-email-greg.pearson@hp.com>
	<20140131151651.26ff54cd7bd06fc5feb6fcc6@linux-foundation.org>
	<52EC48D0.4000503@hp.com>
	<20140131181254.da3f8e97.akpm@linux-foundation.org>
Date: Sun, 02 Feb 2014 14:25:25 -0800
In-Reply-To: <20140131181254.da3f8e97.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 31 Jan 2014 18:12:54 -0800")
Message-ID: <8738k1tane.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19vFSB1iDicaZgV1VlcAqfl+TwG8RpEm0Y=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] vmcore: prevent PT_NOTE p_memsz overflow during header update
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sat, 1 Feb 2014 01:07:29 +0000 "Pearson, Greg" <greg.pearson@hp.com> wrote:
>
>> As far as I know the only consequence of dropping a PT_NOTE entry is 
>> that it would not be available in the crash dump for use in debugging. 
>> I'm not sure how important this data might be for triage. I'm guessing 
>> that in cases where one of these strange PT_NOTE entries shows up with a 
>> size that causes an overflow it probably isn't even a real PT_NOTE entry 
>> so dropping it won't matter, but that's a guess at this point since I'm 
>> still trying to figure out how the bogus entries were created.
>
> Can we detect the crazy-huge notes, skip them and then proceed with
> the following sanely-sized ones?

The only way we can have following sanely-sized notes is if they are in
a separate note segment (one of our extensions for kdump and
/proc/vmcore merges them together).

Eric
