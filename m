Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaBMSfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:35:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaBMSe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:34:58 -0500
Date: Thu, 13 Feb 2014 10:36:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 04/24] tty: Fix ref counting for port krefs
Message-ID: <20140213183616.GA13509@kroah.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
 <1391997564-1805-5-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391997564-1805-5-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 08:59:04PM -0500, Peter Hurley wrote:
> The tty core supports two models for handling tty_port lifetimes;
> the tty_port can use the kref supplied by tty_port (which will
> automatically destruct the tty_port when the ref count drops to
> zero) or it can destruct the tty_port manually.
> 
> For tty drivers that choose to use the port kref to manage the
> tty_port lifetime, it is not possible to safely acquire a port
> reference conditionally. If the last reference is released after
> evaluating the condition but before acquiring the reference, a
> bogus reference will be held while the tty_port destruction
> commences.
> 
> Rather, only acquire a port reference if the ref count is non-zero
> and allow the caller to distinguish if a reference has successfully
> been acquired.
> 
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

