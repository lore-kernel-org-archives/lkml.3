Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934690AbaKMWb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:31:57 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53570 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934378AbaKMWbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:31:55 -0500
Date: Thu, 13 Nov 2014 14:31:50 -0800
From: josh@joshtriplett.org
To: Pieter Smith <pieter@boesman.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 51/56] drivers/char/mem: support compiling out splice
Message-ID: <20141113223150.GB30412@cloud>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
 <1415913813-362-52-git-send-email-pieter@boesman.nl>
 <20141113220911.GA546@kroah.com>
 <CAPho-_JJGy0cwBVfWKL1Gt9ZQZM+Odo7W05bKQ2JLO+TM-ABJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPho-_JJGy0cwBVfWKL1Gt9ZQZM+Odo7W05bKQ2JLO+TM-ABJA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please don't top-post.]

On Thu, Nov 13, 2014 at 11:23:46PM +0100, Pieter Smith wrote:
> Okay with moving the relevant functions to a new translation unit and
> squashing it out in the Makefile

No, you don't need to do that either.  Mark pipe_to_null and
splice_write_null as __maybe_unused, then wrap the initialization of
.splice_write = splice_write_null to make it .splice_write =
splice_p(splice_write_null).  That will avoid adding a single ifdef.

- Josh Triplett
