Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab3CLS2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:28:16 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:36783 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab3CLS2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:28:15 -0400
References: <47BBCF14-C7BC-4C35-826A-52A50EFB8B4B@sonatest.com> <1362690424-324-1-git-send-email-jeff.dagenais@gmail.com> <20130312020909.GA8181@ioremap.net>
In-Reply-To: <20130312020909.GA8181@ioremap.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Message-Id: <03063BB2-C4D2-4620-AD68-4E479A9595F3@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org, olivier@okprods.com
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <jeff.dagenais@gmail.com>
Subject: Re: [PATCH 1/2] w1: ds2408: make value read-back check a Kconfig option
Date: Tue, 12 Mar 2013 14:28:11 -0400
To: Evgeniy Polyakov <zbr@ioremap.net>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-03-11, at 10:09 PM, Evgeniy Polyakov wrote:

> Hi
> 
> On Thu, Mar 07, 2013 at 04:07:03PM -0500, Jean-Francois Dagenais (jeff.dagenais@gmail.com) wrote:
>> De-activating this reading back will effectively half the time required
>> for a write to the output register.
> 
> Are you sure you want this to be compile-time option and not module
> parameter?

My experience showed that having this kind of check was only useful for HW/SW
debug development phases, which usually require debug configs. Later in the
development process, when HW and SW are stable, we usually optimize for actual
production. Removing un-needed debug features and modules.

Assuming that, for historical reasons, implementing this new option as a module
parameter would imply initializing it to "true" (i.e. read-back check enabled),
then user-space or kernel invocation would have to override this to "false" in
order to benefit from the enhancement. I felt that this was an awkward burden to
propagate and maintain outside the kernel's config (.config). Especially since
usually, the debug and release configs are meant exactly for this kind of stuff.

Also, it's not so off from the "Protect DS2433 data with a CRC16" option nearby.

We could do the "best of both worlds" and have the Kconfig influence the init
value of a new module parameter which controls whether we read-back or not...

All that said, kernel style and good practices should win here over my own
experiences as the extra run-time "if" check is not an issue really an issue on
most platform.

Thoughts?
/jfd