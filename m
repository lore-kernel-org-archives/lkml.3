Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbaJ3AN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:13:58 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:42153 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbaJ3AN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:13:56 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org> <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Oct 2014 17:13:34 -0700
Message-ID: <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com>
Subject: Re: kdbus: add code to gather metadata
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org,
        alban.crequy@collabora.co.uk,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 3:33 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> From: Daniel Mack <daniel@zonque.org>
>>
>> A connection chooses which metadata it wants to have attached to each
>> message it receives with kdbus_cmd_hello.attach_flags. The metadata
>> will be attached as items to the messages. All metadata refers to
>> information about the sending task at sending time, unless otherwise
>> stated. Also, the metadata is copied, not referenced, so even if the
>> sending task doesn't exist anymore at the time the message is received,
>> the information is still preserved.
>>

Also, in general, the comments seem to talk about capturing metadata
at the time that a connection is opened, but the actual code seems to
capture metadata all over the place.  I think it needs to be very
clear, both in the code and the interface, when metadata is captured.

And the ns_eq stuff is too far buried (and not even contained in this
patch!) to be easily verified as being correct, whatever correct means
in that context.

--Andy
