Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3EIWSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:18:51 -0400
Received: from www.sr71.net ([198.145.64.142]:32946 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab3EIWSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:18:50 -0400
Message-ID: <518C20C8.3010403@sr71.net>
Date: Thu, 09 May 2013 15:18:48 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [RFC][PATCH 5/7] create __remove_mapping_batch()
References: <20130507211954.9815F9D1@viggo.jf.intel.com> <20130507212001.49F5E197@viggo.jf.intel.com> <20130509221327.GB14840@cerebellum>
In-Reply-To: <20130509221327.GB14840@cerebellum>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 03:13 PM, Seth Jennings wrote:
>> > +	mapping = lru_to_page(remove_list)->mapping;
> This doesn't work for pages in the swap cache as mapping is overloaded to
> hold... something else that I can't remember of the top of my head.  Anyway,
> this happens:

Yup, that's true.  I'm supposed to be using page_mapping() here.  I know
I ran in to that along the way and fixed a few of the sites in my patch,
but missed that one.  I'll fix it up.
