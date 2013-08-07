Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3HGPy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:54:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071Ab3HGPy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:54:26 -0400
Date: Wed, 7 Aug 2013 11:54:16 -0400
From: Dave Jones <davej@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: unused swap offset / bad page map.
Message-ID: <20130807155416.GB25515@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hillf Danton <dhillf@gmail.com>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130807055157.GA32278@redhat.com>
 <CAJd=RBCJv7=Qj6dPW2Ha=nq6JctnK3r7wYCAZTm=REVOZUNowg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBCJv7=Qj6dPW2Ha=nq6JctnK3r7wYCAZTm=REVOZUNowg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


void __lru_cache_add(struct page *page)
{
        struct pagevec *pvec = &get_cpu_var(lru_add_pvec);

        page_cache_get(page);
        if (!pagevec_space(pvec))
                __pagevec_lru_add(pvec);
        pagevec_add(pvec, page);
        put_cpu_var(lru_add_pvec);
}

I added a printk, and found that pagevec_add frequently returns 0. Is that ok ?

What happens to 'page' in this case ?

	Dave

