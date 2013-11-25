Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3KYTDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:03:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756729Ab3KYTDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:03:07 -0500
Date: Mon, 25 Nov 2013 14:02:51 -0500
From: Dave Jones <davej@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Jones <davej@fedoraproject.org>
Subject: Re: [PATCH 3.2 63/87] ext4: fix memory leak in xattr
Message-ID: <20131125190251.GA5047@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, akpm@linux-foundation.org,
	Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	Dave Jones <davej@fedoraproject.org>
References: <lsq.1385387069.559528559@decadent.org.uk>
 <lsq.1385387069.431840285@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1385387069.431840285@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 01:44:29PM +0000, Ben Hutchings wrote:
 > 3.2.53-rc1 review patch.  If anyone has any objections, please let me know.
 > 
 > --- a/fs/ext4/xattr.c
 > +++ b/fs/ext4/xattr.c
 > @@ -1269,6 +1269,8 @@ retry:
 >  				    s_min_extra_isize) {
 >  					tried_min_extra_isize++;
 >  					new_extra_isize = s_min_extra_isize;
 > +					kfree(is); is = NULL;
 > +					kfree(bs); bs = NULL;
 >  					goto retry;
 >  				}
 >  				error = -1;

There was a follow-on patch that frees the bh too.

	Dave

