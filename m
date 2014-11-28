Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaK1Q3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:29:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26720 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaK1Q3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:29:13 -0500
Date: Fri, 28 Nov 2014 19:28:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Patrick Farrell <paf@cray.com>
Cc: =?iso-8859-1?Q?Lo=EFc?= Pefferkorn <loic@loicp.eu>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gdonald@gmail.com" <gdonald@gmail.com>,
        "HPDD-discuss@ml01.01.org" <HPDD-discuss@ml01.01.org>
Subject: Re: [HPDD-discuss] [PATCH] staging: lustre: fix sparse warnings
 related to lock context imbalance
Message-ID: <20141128162850.GJ4911@mwanda>
References: <02a457cec587341d0f1665491f6360323694b008.1417017302.git.loic@loicp.eu>
 <20141126205443.GB10615@kroah.com>
 <20141127183410.GA4582@iron>
 <20141128100045.GC4860@mwanda>
 <DB0C8A206669AC40B1C4E52A8584A6F61496CCB5@CFWEX01.americas.cray.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB0C8A206669AC40B1C4E52A8584A6F61496CCB5@CFWEX01.americas.cray.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 03:45:24PM +0000, Patrick Farrell wrote:
> Dan,
> 
> I disagree about the change suggested here.  In this particular code,
> 'object_attr' is distinct from 'attr', as in a 'setattr' call on an
> inode.  'cl_object' is a distinct thing from an inode/file on disk,
> and specifying it is the objects attr is helpful in understanding
> there is not a direct relationship to 'attr' in the general filesystem
> sense.  (cl_object attrs are used in determining actual on disk
> attributes, but there is not a one-to-one correspondence.)
> 
> I am willing to be corrected, but that is my first feeling here.

I haven't looked at it deeply.  Loïc was suggesting that we need new
locking functions to deal with lustre's unwieldy naming schemes and I
think we should just fix the names...

We already have a cl_attr struct.  Is that different from what
we're locking here?  I don't think anyone will think this takes an inode
argument.

regards,
dan carpenter

