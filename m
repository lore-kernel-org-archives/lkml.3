Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaDNWV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:21:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaDNWV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:21:27 -0400
Date: Mon, 14 Apr 2014 18:21:08 -0400
From: Dave Jones <davej@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] lib/string.c: strlcpy() might read too far
Message-ID: <20140414222108.GA28206@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Andi Kleen <ak@linux.intel.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20140401.161838.1562296825577866979.davem@davemloft.net>
 <20140402084731.GB6018@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402084731.GB6018@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 11:47:31AM +0300, Dan Carpenter wrote:
 > Imagine you have a user controlled variable at the end of a struct which
 > is allocated at the end of a page.  The strlen() could read beyond the
 > mapped memory and cause an oops.
 > 
 > Probably there are two reasons why we have never hit this condition in
 > real life.  First you would have to be really unlucky for all the
 > variables to line up so the oops can happen.  Second we don't do a lot
 > of fuzzing with invalid strings.

The latter isn't necessarily true, trinity does pass all kinds of
garbage, including malformed ascii of various lengths. But what it
doesn't do fully is pass pointers to this junk in every struct we have
in the kernel. (Just the ones it knows about, which for now is mostly
things like sockaddr_t).

Do you have an example struct with layout like you describe ?
It probably wouldn't be much work to teach the fuzzer about it.
(The tricky part is getting such a malformed struct past the validation
 various syscalls do).

	Dave
