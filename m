Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab3H2Dbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 23:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab3H2Dbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 23:31:35 -0400
Date: Thu, 29 Aug 2013 04:30:23 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: dm-devel@redhat.com, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Subject: Re: [dm-devel] [RFC] dm-lc: plan to go to staging
Message-ID: <20130829033023.GH4872@agk-dp.fab.redhat.com>
Mail-Followup-To: Akira Hayakawa <ruby.wktk@gmail.com>, dm-devel@redhat.com,
	Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
	kernelnewbies@kernelnewbies.org
References: <521EA567.1070801@gmail.com> <20130829020555.GA26206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130829020555.GA26206@kroah.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 07:05:55PM -0700, Greg KH wrote:
> For staging drivers, I need a TODO file that lists
> what needs to be done to the code to get it into a mergable state for
> the "real" part of the kernel,

Two simple requirements before putting your proof-of-concept into staging
if you want to work that way:

1) Drop the major version number to 0.  Version 1 is reserved for
supported modules.

2) Agree a new and meaningful target name with us so you don't have to
change it later.  "lc" means nothing, I'm afraid.

Then in general terms, you should continue to compare your device-mapper
target with the existing targets and where there are differences, either
change your target to be like something that already exists, or be ready
to explain why that can't or shouldn't be done.

In particular, the interface and architecture will need substantial
changes and working these out should be your highest priority.

For example, you write:

  Be careful, you MUST create all the LVs as the destinations of
  the dirty blocks on the cache device before this operation.  Otherwise,
  the kernel may crash.

I read a statement like that as an indication of an interface or
architectural problem.  The device-mapper approach is to 'design out'
problems, rather than relying on users not doing bad things.
Study the existing interfaces used by other targets to understand
some approaches that proved successful, then decide which ones
come closest to your needs.

(Your code also needs many more comments inline to explain what it does
and how it works.)

The documentation file will eventually need rewriting to follow the same
format as the other targets recently added to the kernel.  We document
the kernel interface rather than any particular userspace tools, which
just have the status of convenient examples.

Another little thing I noticed: look into using something like
__dm_bless_for_disk() for your metadata and clearly segregate your
on-disk structures and document the layout.

Alasdair

