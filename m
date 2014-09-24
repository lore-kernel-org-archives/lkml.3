Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaIXUqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:46:38 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37035 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbaIXUqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:46:35 -0400
Date: Wed, 24 Sep 2014 14:46:27 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        tpmdd-devel@lists.sourceforge.net,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Message-ID: <20140924204627.GA12407@obsidianresearch.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20140924190234.GB6801@intel.com>
 <20140924201938.GC10887@obsidianresearch.com>
 <201409242235.42286.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201409242235.42286.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:35:42PM +0200, Peter Hüwe wrote:
> Am Mittwoch, 24. September 2014, 22:19:38 schrieb Jason Gunthorpe:
> > On Wed, Sep 24, 2014 at 10:02:34PM +0300, Jarkko Sakkinen wrote:
> > > > The pcrs file never conformed to the sysfs rules, if TPM2 is getting a
> > > > whole new file set, I wouldn't mind seeing it not include the
> > > > non-conformant ones. What do you think?
> > > 
> > > I think that it's better to put extra focus on these sysfs attributes in
> > > first patch set because it's user space visible. What's wrong in the
> > > current pcrs file?
> > 
> > Each PCR should be a distinct sysfs file, probably with a
> > directory. One Value Per File is the rule.
> 
> That would be 24*2 files only for pcrs...

Some subsystems do just that..

$ ls /sys/class/infiniband/qib0/ports/1/sl2vl/
0  1  10  11  12  13  14  15  2  3  4  5  6  7  8  9

> Documentation/filesystems/sysfs.txt says:
> 
> "
> Attributes should be ASCII text files, preferably with only one value
> per file. It is noted that it may not be efficient to contain only one
> value per file, so it is socially acceptable to express an array of
> values of the same type. "
> 
> So it would be more or less o.k. to have it in one file like we had.
> 
> Then however:
> "Mixing types, expressing multiple lines of data, and doing fancy
> formatting of data is heavily frowned upon. Doing these things may get
> you publicly humiliated and your code rewritten without notice."

I think taken together that says an array of 128 bit PCR hex values
without new lines or other formatting would be OK. But the breakdown
and fancy formatting we do is not OK.

> Do we really need the PCRs as sysfs files?  I know they are handy as
> a dev, but does any application actually use this directly?

No idea, but using tpm2 to find out seems like a reasonable idea,
especially if the pcr meaning changes in some way with TPM2 ..

Jason
