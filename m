Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3LKVYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:24:22 -0500
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:47095 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3LKVYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:24:17 -0500
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2013 16:24:17 EST
X-Cam-AntiVirus: found ScamNailer.Phish.viro_AT_zeniv.linux.org.uk
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] hfsplus: Remove hfsplus_file_lookup
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20131211191153.GZ10323@ZenIV.linux.org.uk>
Date: Wed, 11 Dec 2013 21:08:35 +0000
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
        Sougata Santra <sougata@tuxera.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org Mailing List" 
	<linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Szabolcs Szakacsits <szaka@tuxera.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <8B102D87-1A22-4ACA-9438-CA66133C2AB1@cam.ac.uk>
References: <1386780980.9524.10.camel@ultrabook> <AE333CDA-DD74-42B8-92F4-551ACCAD8AFA@dubeyko.com> <20131211191153.GZ10323@ZenIV.linux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11 Dec 2013, at 19:11, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Dec 11, 2013 at 10:49:29PM +0300, Vyacheslav Dubeyko wrote:
>> This feature worked earlier under Linux. So, I suppose that some changes in HFS+ driver
>> or in VFS broke it. And it needs to investigate and fix the reported issue. Thank you for the
>> report.
> 
> This "feature" is severely broken and yes, outright removal is what I'd
> suggest for a fix.  HFS+ allows hardlinks to files, which means that
> you allow multiple dentries for the same inode with ->lookup() in it,
> which is asking for deadlocks.
> 
> This is fundamentally not supported.  Considering that forks are lousy
> idea in the first place, I'd seriously suggest to remove that idiocy for
> good.

Completely agree with Al.  If anyone really wants access to forks they can implement them via the xattr interface (ok it has the 64k limitation but most forks are quite small so not much of an issue).  That's how I implemented access to named streams in Tuxera NTFS and it works a treat (and allows Linux apps and various security modules that require xattr support to work properly which is also great).

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge
J.J. Thomson Avenue, Cambridge, CB3 0RB, UK

