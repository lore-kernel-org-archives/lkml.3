Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBSXpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:45:16 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33624 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaBSXpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:45:15 -0500
Date: Wed, 19 Feb 2014 23:42:18 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kelley Nielsen <kelleynnn@gmail.com>, riel@surriel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        opw-kernel@googlegroups.com, jamieliu@google.com,
        sjenning@linux.vnet.ibm.com, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] mm:prototype for the updated swapoff implementation
Message-ID: <20140219234218.51c84c08@alan.etchedpixels.co.uk>
In-Reply-To: <20140219132757.58b61f07bad914b3848275e9@linux-foundation.org>
References: <20140219003522.GA8887@kelleynnn-virtual-machine>
	<20140219132757.58b61f07bad914b3848275e9@linux-foundation.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you have situations in which swapoff is taking an unacceptable
> amount of time?  If so, please update the changelog to provide full
> details on this, with before-and-after timing measurements.

Yes - because now and then (about once a month) with 3.10 or so + and
encrypted swap my box with 16GB RAM gets into a weird 'slow swapping'
state and only swapoff/swapon gets it back to sanity.

In those cases (and in general) swapoff can take half an hour to run.

There is a reproducer for the swap hang at
https://bugzilla.kernel.org/show_bug.cgi?id=62321

The case I see in normal use (gimp of 1200dpi+ A3 images) hits a crawl
not a hang and does recover but only if you swapoff/swapon again

Alan
