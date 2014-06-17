Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbaFQTSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:18:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbaFQTSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:18:00 -0400
Date: Tue, 17 Jun 2014 12:21:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Lameter <cl@gentwo.org>, Jeff Liu <jeff.liu@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, stefanr@s5r6.in-berlin.de, joro@8bytes.org,
        jejb@parisc-linux.org, deller@gmx.de, bhelgaas@google.com, clm@fb.com,
        Josef Bacik <jbacik@fb.com>, swhiteho@redhat.com, bharrosh@panasas.com,
        bhalevy@primarydata.com, ccaulfie@redhat.com, teigland@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        jaegeuk@kernel.org, cm224.lee@samsung.com,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        casey@schaufler-ca.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/24] kobject: return actual error on kset_create_and_add
Message-ID: <20140617192152.GA4319@kroah.com>
References: <53A04FF7.5050900@oracle.com>
 <20140617154730.GA14153@kroah.com>
 <alpine.DEB.2.11.1406171057270.20610@gentwo.org>
 <1403021389.27991.11.camel@dabdike.int.hansenpartnership.com>
 <alpine.DEB.2.11.1406171128540.20610@gentwo.org>
 <1403024089.1995.0.camel@jarvis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403024089.1995.0.camel@jarvis>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 09:54:49AM -0700, James Bottomley wrote:
> On Tue, 2014-06-17 at 11:29 -0500, Christoph Lameter wrote:
> > On Tue, 17 Jun 2014, James Bottomley wrote:
> > 
> > > What useful information does this supply?  The current assumption on
> > > NULL return is -ENOMEM ... what's the interesting case where this
> > > assumption is wrong?
> > 
> > No idea. Sysfs just ignored all error codes and returns NULL right now.
> > If it is indeed just ENOMEN then we have no issue.
> 
> Well, I think when we have that justification, then we can decide on the
> merits of the patch set.

There is one error patch in this function that is not due to a -ENOMEM
error, but that will generate a huge message in the syslog describing
what happened (created with the same name, or some other reason), so it
would not make sense to duplicate another error message in the log by
the caller code.

So again, I don't see any use for this patch at all, except to cause
problems (mix of maintainers applying the follow-on patches and others
not).

Everyone, please do not apply any of these patches that were sent to
you in this series.

thanks,

greg k-h
