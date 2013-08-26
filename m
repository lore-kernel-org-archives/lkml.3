Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3HZUmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:42:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3HZUmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:42:51 -0400
Date: Mon, 26 Aug 2013 13:42:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Svenning =?ISO-8859-1?Q?S=F8rensen?= <sss@secomea.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPC: bugfix for msgrcv with msgtyp < 0
Message-Id: <20130826134250.66830c1a551f6619544bd6a8@linux-foundation.org>
In-Reply-To: <5218ABD5.1000400@hurleysoftware.com>
References: <52189CB1.9030806@secomea.dk>
	<5218ABD5.1000400@hurleysoftware.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Aug 2013 08:49:25 -0400 Peter Hurley <peter@hurleysoftware.com> wrote:

> On 08/24/2013 07:44 AM, Svenning S__rensen wrote:
> > According to 'man msgrcv':
> > "If msgtyp is less than 0, the first message of the lowest type that is less
> > than or equal to the absolute value of msgtyp shall be received."
> >
> > Bug: The kernel only returns a message if its type is 1; other messages with
> > type < abs(msgtype) will never get returned.
> >
> > Fix: After having traversed the list to find the first message with the
> > lowest type, we need to actually return that message.
> 
> Sorry for the breakage. Needs to go to -stable as well.

Do you know which commit caused the regression?  That would help those
who wish to fix up their kernels.

> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
> 
