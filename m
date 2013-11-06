Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab3KFV0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:26:25 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:39968 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab3KFV0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:26:24 -0500
MIME-Version: 1.0
In-Reply-To: <20131106141740.GA16072@x1.alien8.de>
References: <527940181131657a6@agluck-desk.sc.intel.com>
	<20131106141740.GA16072@x1.alien8.de>
Date: Wed, 6 Nov 2013 13:26:23 -0800
Message-ID: <CA+8MBb+EBHPeB6ND4BjvaziuriAqjs-XxJyNCpBKK0b4SQptxQ@mail.gmail.com>
Subject: Re: [PATCH] Changes to the ACPI/APEI/EINJ debugfs interface
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chen Gong <gong.chen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 6:17 AM, Borislav Petkov <bp@alien8.de> wrote:
> I wonder if, at some point in the future - not now, necessarily, it'll
> be prudent to add an error injection struct descriptor which contains
> all those param* thingies and some of them could even be defined as a
> union in it in order to make the whole code more readable. Like the
> 'address' variable, for example, which is valid for multiple error
> types...
>
> Just an idea though, so let me throw it out in the open.

That would indeed be a nice cleanup for later ... that many arguments
to a function is tickling my threshold for "this ought to be simpler".
Especially as we pass them all through einj_error_inject() on the way
to __einj_error_inject().  Perhaps don't even need a new structure,
just fill them into the existing set_error_type_with_address struct
(which is the format they need to be in to pass to the BIOS).

-Tony
