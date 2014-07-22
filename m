Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaGVLna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:43:30 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:40913 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbaGVLn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:43:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/k32KBfuvrDb6qNZAhfum6t1i6HZ1ysyE=
X-DKIM: OpenDKIM Filter v2.0.1 titan 529765B276C
Date: Tue, 22 Jul 2014 07:43:20 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, keescook@chromium.org,
        Amos Kong <akong@redhat.com>
Subject: Re: [PATCH v2 3/4] virtio: rng: delay hwrng_register() till driver
 is ready
Message-ID: <20140722114320.GB18750@titan.lakedaemon.net>
References: <cover.1405942162.git.amit.shah@redhat.com>
 <91cb7c5b87cf2ba5ef1bacd55a7ee7bc827293a2.1405942162.git.amit.shah@redhat.com>
 <20140721121116.GA18750@titan.lakedaemon.net>
 <20140721124124.GA7846@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721124124.GA7846@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 08:41:24PM +0800, Herbert Xu wrote:
> On Mon, Jul 21, 2014 at 08:11:16AM -0400, Jason Cooper wrote:
> >
> > > @@ -136,15 +137,6 @@ static int probe_common(struct virtio_device *vdev)
> > >  		return err;
> > >  	}
> > >  
> > > -	err = hwrng_register(&vi->hwrng);
> > > -	if (err) {
> > > -		vdev->config->del_vqs(vdev);
> > > -		vi->vq = NULL;
> > > -		kfree(vi);
> > > -		ida_simple_remove(&rng_index_ida, index);
> > > -		return err;
> > > -	}
> > > -
> > 
> > This needs to stay.  register, and failure to do so, should occur in the
> > probe routine.
> 
> Why? 

hmm, yes. On reviewing the code, my objection was silly.  It mostly
stemmed from the commit message's mentioning of reduced error handling.

thx,

Jason.
