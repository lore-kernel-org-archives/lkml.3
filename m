Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaCKBZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:25:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbaCKBZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:25:10 -0400
Date: Mon, 10 Mar 2014 21:24:55 -0400
From: Dave Jones <davej@redhat.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: oops in slab/leaks_show
Message-ID: <20140311012455.GA5151@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Christoph Lameter <cl@linux.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	David Rientjes <rientjes@google.com>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20140307025703.GA30770@redhat.com>
 <alpine.DEB.2.10.1403071117230.21846@nuc>
 <20140311003459.GA25657@lge.com>
 <20140311010135.GA25845@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311010135.GA25845@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 10:01:35AM +0900, Joonsoo Kim wrote:
 > On Tue, Mar 11, 2014 at 09:35:00AM +0900, Joonsoo Kim wrote:
 > > On Fri, Mar 07, 2014 at 11:18:30AM -0600, Christoph Lameter wrote:
 > > > Joonsoo recently changed the handling of the freelist in SLAB. CCing him.
 > > > 
 > > > > I pretty much always use SLUB for my fuzzing boxes, but thought I'd give SLAB a try
 > > > > for a change.. It blew up when something tried to read /proc/slab_allocators
 > > > > (Just cat it, and you should see the oops below)
 > > 
 > > Hello, Dave.
 > > 
 > > Today, I did a test on v3.13 which contains all my changes on the handling of
 > > the freelist in SLAB and couldn't trigger oops by just 'cat /proc/slab_allocators'.
 > > 
 > > So I look at the code and find that there is race window if there is multiple users
 > > doing 'cat /proc/slab_allocators'. Did your test do that?
 > 
 > Opps, sorry. I am misunderstanding something. Maybe there is no race.
 > Anyway, How do you test it?

1. build kernel with CONFIG_SLAB=y.
2. boot kernel
3. cat /proc/slab_allocators

that's it.

	Dave

