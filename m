Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3H1Jrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:47:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab3H1Jrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:47:35 -0400
Date: Wed, 28 Aug 2013 12:46:30 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
Message-ID: <20130828094630.GR22899@redhat.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130828092001.GQ22899@redhat.com>
 <521DC3FD.1020507@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521DC3FD.1020507@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 05:33:49PM +0800, Xiao Guangrong wrote:
> > Or what if desc is moved to another rmap, but then it
> > is moved back to initial rmap (but another place in the desc list) so
> > the check here will not catch that we need to restart walking?
> 
> It is okay. We always add the new desc to the head, then we will walk
> all the entires under this case.
> 
Which races another question: What if desc is added in front of the list
behind the point where lockless walker currently is?

> Right?
Not sure. While lockless walker works on a desc rmap can be completely
destroyed and recreated again. It can be any order.

--
			Gleb.
