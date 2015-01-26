Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbbAZTlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:41:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbbAZTlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:41:00 -0500
Message-ID: <54C6984A.20501@redhat.com>
Date: Mon, 26 Jan 2015 14:40:58 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: inverse mapping from a struct console to device
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

TLDR: I need a back reference from a console struct to its device. I
can't see an easy way to do this right now without adding one?

I've a quick question. I have prototype code that parses an ACPI table
known as the SPCR (Serial Port Console Redirection - exists on both x86
and ARM systems). It finds the correct serial device (but it's not a
Linux specific DT-style solution so there's no "console=" parameter
embedded in it or something) to use for the preferred console (I have
effectively the device object connected with the acpi_handle of the
underlying serial device, which I map on by walking the ACPI namespace
down from the root until I find the _ADR of the specified SPCR address).

One of the problems that I have is that I want to make the decision
about whether a console should be automatically configured once we get
to register_console, because that's where the existing logic is, and
it's one path I can be sure everyone is going to call (serial drivers
have a number of different APIs that they use during registration).

Once I'm in register_console, I have only the console struct to play
with. I can get from that to the tty_driver (by walking the tty driver
list and finding the back reference), but that still doesn't give me
what I want. I can add a reference to the underlying device in one of
these structs, but I would like to have additional opinions before I go
and make something hackish folks will balk at later. So, am I missing
something obvious? I hope I am because this seems slightly weird.

Jon.

P.S. I would love it if I could (for debug purposes only) just walk down
from the root of the kernel device hierarchy until I found a device that
had a resource matching the one I am looking for (you can do exactly
this in the ACPI namespace using exported methods), but the only code
that can do that today is unexported core core used during shutdown to
shutdown all devices recursively. Just a sidenote.
