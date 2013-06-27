Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab3F0WCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:02:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3F0WCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:02:32 -0400
Date: Thu, 27 Jun 2013 15:02:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mhocko@suse.cz,
        minchan@kernel.org, anton@enomsg.org, kmpark@infradead.org,
        hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-Id: <20130627150231.2bc00e3efcd426c4beef894c@linux-foundation.org>
In-Reply-To: <20130626231712.4a7392a7@redhat.com>
References: <20130626231712.4a7392a7@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 23:17:12 -0400 Luiz Capitulino <lcapitulino@redhat.com> wrote:

> Currently, an eventfd is notified for the level it's registered for
> _plus_ higher levels.
> 
> This is a problem if an application wants to implement different
> actions for different levels. For example, an application might want
> to release 10% of its cache on level low, 50% on medium and 100% on
> critical. To do this, an application has to register a different
> eventfd for each pressure level. However, fd low is always going to
> be notified and and all fds are going to be notified on level critical.
> 
> Strict mode solves this problem by strictly notifiying an eventfd
> for the pressure level it registered for. This new mode is optional,
> by default we still notify eventfds on higher levels too.
> 

It didn't take long for this simple interface to start getting ugly :(
And having the fd operate in different modes is ugly.

Can we instead pass the level in the event payload?

