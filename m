Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936673Ab3DJOJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:09:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22784 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760108Ab3DJOJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:09:14 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZzSxI7jMevMA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=mVTtbqeYs4EA:10 a=TxvQE9YX0FHs4Y0EX7MA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365602951.9609.10.camel@gandalf.local.home>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Date: Wed, 10 Apr 2013 10:09:11 -0400
In-Reply-To: <0000013df43f6fe0-8b71a9f4-bad1-417e-ab44-797c5ba2aecd-000000@email.amazonses.com>
References: <1364355032.6345.200.camel@gandalf.local.home>
	 <20130327061351.GB17125@lge.com>
	 <alpine.DEB.2.02.1303281227520.16200@gentwo.org>
	 <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
	 <CAP=VYLr4i=39ywFCrmG-XuvUFmmXpyj6dYgG44JJoUJhpN6uuQ@mail.gmail.com>
	 <alpine.DEB.2.02.1304011025550.12690@gentwo.org>
	 <0000013dc63b3a87-6ce88b75-d011-407e-8dde-da73c3a7f5fd-000000@email.amazonses.com>
	 <20130402004217.GA16699@lge.com>
	 <1365424372.25498.6.camel@gandalf.local.home>
	 <CAOJsxLH2axjptbMj9caH0Wo_OqPZRVB20q7uT6f9dVtPZZxb_w@mail.gmail.com>
	 <20130410073143.GF5872@lge.com>
	 <0000013df43f6fe0-8b71a9f4-bad1-417e-ab44-797c5ba2aecd-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 14:00 +0000, Christoph Lameter wrote:
> On Wed, 10 Apr 2013, Joonsoo Kim wrote:
> 
> > > Christoph, Joonsoo, comments?
> >
> > Steven's comment is reasonable to me.
> >
> > If there is no objection from Christoph,
> > let's drop a patch in which I implement Christoph's idea.
> 
> Fine with me.
> 
> I do not like passing a reference just because we have to
> return an additional counter. Adds a lot of overhead.
> 

The reference is only passed to acquire_slab() which is a static inline
function that's only called by this function. You would think that gcc
can optimize that to remove the "lot of overhead".

-- Steve


