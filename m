Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab3HNVuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:50:06 -0400
Received: from www.sr71.net ([198.145.64.142]:43351 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933238Ab3HNVuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:50:04 -0400
Message-ID: <520BFB87.6050207@sr71.net>
Date: Wed, 14 Aug 2013 14:49:59 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] drivers: base: dynamic memory block creation
References: <1376508705-3188-1-git-send-email-sjenning@linux.vnet.ibm.com> <520BECDF.8060501@sr71.net> <20130814211454.GA17423@variantweb.net> <520BF88C.6060202@linux.vnet.ibm.com>
In-Reply-To: <520BF88C.6060202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 02:37 PM, Cody P Schafer wrote:
> Also, I'd expect userspace tools might use readdir() to find out what
> memory blocks a system has (unless they just stat("memory0"),
> stat("memory1")...). I don't think filesystem tricks (at least within
> sysfs) are going to let this magically be solved without breaking the
> userspace API.

sysfs files are probably a bit too tied to kobjects to make this work
easily in practice.  It would probably need to be a new filesystem, imnho.

But, there's nothing to keep you from creating dentries for all of the
memory blocks if someone _does_ a readdir().  It'll suck, of course, but
it's at least compatible with what's there.  You could also 'chmod -x'
it to make it more obvious that folks shouldn't be poking around in
there, although it won't keep them from ls'ing.  If you're concerned
about resource consumption, we could also just make the directory
unreadable to everyone but root.
