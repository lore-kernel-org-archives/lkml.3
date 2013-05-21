Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3EUK05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:26:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab3EUK04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:26:56 -0400
Date: Tue, 21 May 2013 12:26:48 +0200
From: Karel Zak <kzak@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, hughd@google.com,
        shli@kernel.org, jmoyer@redhat.com, riel@redhat.com,
        lwoodman@redhat.com, mgorman@suse.de
Subject: Re: [RFC PATCH 02/02] swapon: add "cluster-discard" support
Message-ID: <20130521102648.GB11774@x2.net.home>
References: <cover.1369092449.git.aquini@redhat.com>
 <398ace0dd3ca1283372b3aad3fceeee59f6897d7.1369084886.git.aquini@redhat.com>
 <519AC7B3.5060902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519AC7B3.5060902@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 09:02:43PM -0400, KOSAKI Motohiro wrote:
> > -	if (fl_discard)
> > +	if (fl_discard) {
> >  		flags |= SWAP_FLAG_DISCARD;
> > +		if (fl_discard > 1)
> > +			flags |= SWAP_FLAG_DISCARD_CLUSTER;
> 
> This is not enough, IMHO. When running this code on old kernel, swapon() return EINVAL.
> At that time, we should fall back swapon(0x10000).

 Hmm.. currently we don't use any fallback for any swap flag (e.g.
 0x10000) for compatibility with old kernels. Maybe it's better to
 keep it simple and stupid and return an error message than introduce
 any super-smart semantic to hide incompatible fstab configuration.

    Karel
 
-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
