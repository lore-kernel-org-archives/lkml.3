Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbaFQPPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:15:39 -0400
Received: from imap.thunk.org ([74.207.234.97]:43155 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933295AbaFQPPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:15:37 -0400
Date: Tue, 17 Jun 2014 11:14:27 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: gregkh@linuxfoundation.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stefanr@s5r6.in-berlin.de, joro@8bytes.org, jejb@parisc-linux.org,
        deller@gmx.de, bhelgaas@google.com, clm@fb.com,
        Josef Bacik <jbacik@fb.com>, swhiteho@redhat.com, bharrosh@panasas.com,
        bhalevy@primarydata.com, ccaulfie@redhat.com, teigland@redhat.com,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, cm224.lee@samsung.com,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        casey@schaufler-ca.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/24] lib/kobject: kset_create_and_add return error
 clean up
Message-ID: <20140617151427.GC5054@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jeff Liu <jeff.liu@oracle.com>, gregkh@linuxfoundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
	benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
	heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, stefanr@s5r6.in-berlin.de, joro@8bytes.org,
	jejb@parisc-linux.org, deller@gmx.de, bhelgaas@google.com,
	clm@fb.com, Josef Bacik <jbacik@fb.com>, swhiteho@redhat.com,
	bharrosh@panasas.com, bhalevy@primarydata.com, ccaulfie@redhat.com,
	teigland@redhat.com, adilger.kernel@dilger.ca, jaegeuk@kernel.org,
	cm224.lee@samsung.com, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, casey@schaufler-ca.com,
	LKML <linux-kernel@vger.kernel.org>
References: <53A04FDA.6070101@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A04FDA.6070101@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:25:30PM +0800, Jeff Liu wrote:
> Hello,
> 
> Currently, to verify if kset_create_and_add() is succeed or not, almost
> all subsystems with sysfs support are check up the return value against
> NULL, then return -ENOMEM on failure, since kset_create_and_add() always 
> return NULL in case of anything wrong.  However, kset_register() can fail
> due to other reasons, hence it's better to return the actual error on
> kset_create_and_add(), this patch series is just did that and this is
> inspired by Christoph in another thread:
> http://www.spinics.net/lists/linux-mm/msg74729.html

Number one, please, please, please use git send-email with
sendmail.chainreplyto set to true in your .gitconfig (which is the
default) or use --chain-reply-to.  Without reply chaining, it's
incredibly painful to find related patches, and these patches are very
clearly related.

Number two, for changes like this, my strong recommendation is to have
a single large patch that makes all of the change at once.  Breaking
up the commits into each individual patch just adds a lot of noise
into the system, and it also invites potential problems when people
find a single patch out of context, and might accidentally backport
the patch (which as described, sounds like it's a bug fix) without
realizing that it's actively harmful until you apply the first patch
in this patch series.

In additoin, when you make an API change like this, and then spread
out the changes across two dozen patches, it also breaks
bisectability, although in this case the chance that
kset_create_and_add would fail is relatively small.  It's the
principle of the thing, though.

For the ext4 portion of this patch set (which I think should be a
single patch):

Acked-by: Theodore Ts'o <tytso@mit.edu> 

	  	   			     - Ted
