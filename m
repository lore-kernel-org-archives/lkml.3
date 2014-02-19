Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaBSKxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:53:46 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:63347 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaBSKxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:53:44 -0500
MIME-Version: 1.0
In-Reply-To: <95FE2F33-B9C5-4F24-B639-3F1D42EFD1E1@codeaurora.org>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
	<1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
	<95FE2F33-B9C5-4F24-B639-3F1D42EFD1E1@codeaurora.org>
Date: Wed, 19 Feb 2014 16:23:44 +0530
Message-ID: <CAJe_ZhcEg--zSqEJVYz-pNRiEgz4DrsYFTK3WTHSsF9jE3vzTA@mail.gmail.com>
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

On 19 February 2014 03:02, Kumar Gala <galak@codeaurora.org> wrote:
>
> On Feb 15, 2014, at 12:25 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>
>> Introduce common framework for client/protocol drivers and
>> controller drivers of Inter-Processor-Communication (IPC).
>>
>> Client driver developers should have a look at
>> include/linux/mailbox_client.h to understand the part of
>> the API exposed to client drivers.
>> Similarly controller driver developers should have a look
>> at include/linux/mailbox_controller.h
>>
>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>> ---
>> drivers/mailbox/Makefile           |   4 +
>> drivers/mailbox/mailbox.c          | 534 +++++++++++++++++++++++++++++++++++++
>> include/linux/mailbox.h            |  17 ++
>> include/linux/mailbox_client.h     |  87 ++++++
>> include/linux/mailbox_controller.h | 102 +++++++
>> 5 files changed, 744 insertions(+)
>> create mode 100644 drivers/mailbox/mailbox.c
>> create mode 100644 include/linux/mailbox.h
>> create mode 100644 include/linux/mailbox_client.h
>> create mode 100644 include/linux/mailbox_controller.h
>
> What's the intent of trying to provide a unified interface here?  I'm trying to understand what benefit we are going for, I get possibly wanting something to reduce duplication in drivers (help functions, library, etc).  But do we really see benefit in a common interface for clients?
>
> Are we really going to mix a OMAP mailbox controller with a client developed for some other SoC vendor?
>
Yeah :)  we may never a client reused on some other platform and that
is why I didn't yet bother implementing DT bindings to map random
clients onto mailboxes. Clients are going to be _very_ specific to
platforms(controller + remote f/w) and so we have the 'luxury' of
hardcoding that info(exact id of the mailbox) into client's code.

 Apart from controllers and clients sharing helper functions in the
api, we'll also soon run into various platforms using the same mailbox
controller (or a slightly modified version) and having to support
completely different protocols, and hence clients. Clearly we don't
want to have pl320_highbank.c, pl320_abc.c and pl320_xyz.c for three
different platforms. So we need the common/shared code to also help a
controller driver to behave differently on different platforms
(clients could pass platform specific info to the common controller
driver).

-jassi
