Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3CaLsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 07:48:42 -0400
Received: from mail3.vodafone.ie ([213.233.128.45]:63473 "EHLO
	mail3.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3CaLsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 07:48:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0EAMohWFFtTP75/2dsb2JhbAANNoM7v2YDAYEfeIIbAQEBBDIBRhALDQEKCRYPCQMCAQIBRQYNAQcBAYgcrTSSRY1lbV8Hg0ADmAqFBY1zgWkJGw
Message-ID: <51582294.1000806@draigBrady.com>
Date: Sun, 31 Mar 2013 12:48:36 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andreas Dilger <adilger@dilger.ca>
CC: Pavel Machek <pavel@ucw.cz>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Andy Lutomirski <luto@amacapital.net>, Zach Brown <zab@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
References: <512606DF.5050706@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com> <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com> <20130221222449.GY22221@lenny.home.zabbo.net> <512BD44C.40907@amacapital.net> <20130226210232.GA19510@logfs.org> <20130330194933.GB1005@amd.pavel.ucw.cz> <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca>
In-Reply-To: <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 08:08 PM, Andreas Dilger wrote:
> On 2013-03-30, at 12:49 PM, Pavel Machek wrote:
>> Hmm, really? AFAICT it would be simple to provide an
>> open_deleted_file("directory") syscall. You'd open_deleted_file(),
>> copy source file into it, then fsync(), then link it into filesystem.
>>
>> That should have atomicity properties reflected.
> 
> Actually, the open_deleted_file() syscall is quite useful for many
> different things all by itself.  Lots of applications need to create
> temporary files that are unlinked at application failure (without a
> race if app crashes after creating the file, but before unlinking).
> It also avoids exposing temporary files into the namespace if other
> applications are accessing the directory.
> 
> We've added a library routine that does this for Lustre in a hackish
> way (magical filename created in target directory) for being able to
> migrate files between data servers, HSM, defragmentation, rsync, etc.
> 
> Cheers, Andreas

This reminds me of the flink() discussion:
http://marc.info/?l=linux-kernel&m=104965452917349

Also kinda related is the exchangedata() OSX system call to
"atomically exchange data between two files"

thanks,
Pádraig.
