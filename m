Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbaFQQJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:09:55 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49627 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755631AbaFQQJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:09:54 -0400
Message-ID: <1403021389.27991.11.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 01/24] kobject: return actual error on
 kset_create_and_add
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jeff Liu <jeff.liu@oracle.com>,
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
Date: Tue, 17 Jun 2014 09:09:49 -0700
In-Reply-To: <alpine.DEB.2.11.1406171057270.20610@gentwo.org>
References: <53A04FF7.5050900@oracle.com> <20140617154730.GA14153@kroah.com>
	 <alpine.DEB.2.11.1406171057270.20610@gentwo.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 11:00 -0500, Christoph Lameter wrote:
> On Tue, 17 Jun 2014, Greg KH wrote:
> 
> > Who really cares about that?  What can do you do with that additional
> > information that will help anything out?
> 
> The obvious reason for doing so is so that one can put the error code into
> a log message to get more detailed information on why the call failed.
> 
> In this particular case the slab allocator can give an error message that
> gives a hint why the sysfs support could not be enabled.

What useful information does this supply?  The current assumption on
NULL return is -ENOMEM ... what's the interesting case where this
assumption is wrong?

James


