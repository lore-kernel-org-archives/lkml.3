Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3IYDLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:11:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab3IYDLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:11:44 -0400
Date: Tue, 24 Sep 2013 23:11:27 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chen Gang <gang.chen@asianux.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, mempolicy: make mpol_to_str robust and always succeed
Message-ID: <20130925031127.GA4210@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Chen Gang <gang.chen@asianux.com>, Rik van Riel <riel@redhat.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <5215639D.1080202@asianux.com>
 <5227CF48.5080700@asianux.com>
 <alpine.DEB.2.02.1309241957280.26415@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309241957280.26415@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 07:58:22PM -0700, David Rientjes wrote:

 >  	case MPOL_BIND:
 > -		/* Fall through */
 >  	case MPOL_INTERLEAVE:
 >  		nodes = pol->v.nodes;
 >  		break;

Any reason not to leave this ?

"missing break" is the 2nd most common thing that coverity picks up.
Most of them are false positives like the above, but the lack of annotations
in our source makes it time-consuming to pick through them all to find the
real bugs.

	Dave

