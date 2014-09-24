Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaIXUeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:34:36 -0400
Received: from mout.gmx.net ([212.227.15.19]:54585 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaIXUeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:34:19 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Date: Wed, 24 Sep 2014 22:35:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.16.2-dirty; KDE/4.12.5; x86_64; ; )
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        tpmdd-devel@lists.sourceforge.net,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com> <20140924190234.GB6801@intel.com> <20140924201938.GC10887@obsidianresearch.com>
In-Reply-To: <20140924201938.GC10887@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409242235.42286.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:sjeumTQjLCos45oRExqticJaENW5ScRn4Mf4KREvU2AtTDLsmz7
 Aucj044J1OtM5dfSOszqDy2THxkgEieWNb0JIY890xMFsyFYYrJMD1ugHEeH0Sf6oDnngo+
 CsfqrjkcJa4AI3tsjKvQiaNihQro5Hdw/+b8RsvvmJ+kY/z+jiAi/VzNgdyIZiDUb0Pm+5J
 SoJdGSdZVliWbrUbCx+Jw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. September 2014, 22:19:38 schrieb Jason Gunthorpe:
> On Wed, Sep 24, 2014 at 10:02:34PM +0300, Jarkko Sakkinen wrote:
> > > The pcrs file never conformed to the sysfs rules, if TPM2 is getting a
> > > whole new file set, I wouldn't mind seeing it not include the
> > > non-conformant ones. What do you think?
> > 
> > I think that it's better to put extra focus on these sysfs attributes in
> > first patch set because it's user space visible. What's wrong in the
> > current pcrs file?
> 
> Each PCR should be a distinct sysfs file, probably with a
> directory. One Value Per File is the rule.

That would be 24*2 files only for pcrs... 
Documentation/filesystems/sysfs.txt says:

"
Attributes should be ASCII text files, preferably with only one value
per file. It is noted that it may not be efficient to contain only one
value per file, so it is socially acceptable to express an array of
values of the same type. "

So it would be more or less o.k. to have it in one file like we had.


Then however:
"Mixing types, expressing multiple lines of data, and doing fancy
formatting of data is heavily frowned upon. Doing these things may get
you publicly humiliated and your code rewritten without notice."


Do we really need the PCRs as sysfs files?
I know they are handy as a dev, but does any application actually use this 
directly?


Thanks,
Peter



