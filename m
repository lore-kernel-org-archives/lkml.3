Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbaFCVEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:04:46 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:45770 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaFCVEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:04:44 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:e054:7632:66c1:4b6d]
In-Reply-To: <20140603203318.GB6582@kroah.com>
References: <1401826402-1079-1-git-send-email-galak@codeaurora.org>
	<20140603203318.GB6582@kroah.com>
Date: Tue, 3 Jun 2014 14:04:43 -0700
Message-ID: <CAOesGMh5knixNp+dgWnQu5M00N4ZMm10PoBh3YVTquryfRh-cw@mail.gmail.com>
Subject: Re: [PATCH] tty: serial: msm: Fix section mismatch warning
From: Olof Johansson <olof@lixom.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kumar Gala <galak@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 1:33 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jun 03, 2014 at 03:13:22PM -0500, Kumar Gala wrote:
>> WARNING: drivers/tty/built-in.o(.data+0x3544): Section mismatch in
>> reference from the variable msm_platform_driver to the function
>> .init.text:msm_serial_probe()
>> The variable msm_platform_driver references
>> the function __init msm_serial_probe()
>> If the reference is valid then annotate the
>> variable with __init* or __refdata (see linux/init.h) or name the variable:
>> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
>
> Where is this mismatch showing up at?  3.15-rc8, 3.16-rc1?  Somewhere
> older or else?

Linus' next branch, it was merged through arm-soc. I didn't notice it
in time to fix it before we sent to Linus. :(


-Olof
