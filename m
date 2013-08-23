Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3HWNOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:14:14 -0400
Received: from smtp.infotech.no ([82.134.31.41]:54455 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab3HWNOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:14:12 -0400
Message-ID: <52175FE6.4040309@interlog.com>
Date: Fri, 23 Aug 2013 15:13:10 +0200
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Chris Mason <chris.mason@fusionio.com>,
        Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>,
        James Bottomley <JBottomley@Parallels.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/9] target: Add support for EXTENDED_COPY (VAAI) offload
 emulation
References: <1377224821-23422-1-git-send-email-nab@daterainc.com> <521741B7.9020904@interlog.com> <yq17gfc60yd.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq17gfc60yd.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-08-23 02:33 PM, Martin K. Petersen wrote:
>>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:
>
> Doug> The SCSI opcodes associated with it (0x83 and 0x84) have been
> Doug> renamed THIRD PARTY COPY OUT and IN, and
>
> Where did you see that? My SPC still has EXTENDED COPY.

SCSI _opcodes_ == SCSI operation codes. In other words the
name associated with all service actions (commands) that have
as their first byte 0x83 and 0x84 .

spc4r36h.pdf Annex F.3.1 and changed in spc4r34. Yes, well
hidden but IMO useful. So now we can use the term "Third party
copy" to cover:
   - EXTENDED COPY(LID1) and associated commands
     also found in SPC-2 and SPC-3 (with the "LID1" suffix)
   - EXTENDED COPY(LID4) and associated commands
   - the XCOPY LITE commands: POPULATE TOKEN and WRITE USING TOKEN

> Doug> Confused? I certainly was.
>
> Yeah, this is UNMAP all over again, just 100 times worse :(

Well what EXTENDED COPY (offload copy) is trying to do
ain't simple but obviously there could be a substantial
performance pay-off.

There is a "Third-party copy implementation and usage" Annex
(D) in spc4r36h.pdf . It could do with some more explanatory
text.

> Anyway. Excited to see nab posting the patches! My copy offload code
> from the spring has been getting stale both in the T10 and the kernel
> sense. But at least we know what I'll be working on next week :)

BTW I have ported the sg_xcopy "LID1" xcopy logic into
my ddpt utility. That gives two advantages:
   - can cope with ibs!=obs
   - runs on OSes other than Linux

Doug Gilbert


