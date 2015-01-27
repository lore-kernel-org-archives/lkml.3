Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbbA0Wj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:39:29 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:58360 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbbA0Wj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:39:28 -0500
Date: Tue, 27 Jan 2015 22:39:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mason <mpeg.blue@free.fr>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: Embedded white space in out-of-tree module full pathname
Message-ID: <20150127223922.GQ26493@n2100.arm.linux.org.uk>
References: <54C75E09.6050002@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C75E09.6050002@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 10:44:41AM +0100, Mason wrote:
> I'd like some confirmation that this is either not supported, or that
> I'm doing something obviously wrong. (Kernel 3.14 if it matters.)

It's something which isn't going to be supported.

Various things in the make makes it difficult - for example:

module-dirs := $(addprefix _module_,$(KBUILD_EXTMOD))

and as per your example, addprefix will see "/tmp/foo" and "bar/module"
as two separate words.  make has no way to know that these are one
path rather than two separate paths.

See the addprefix documentation in make's info pages, which splits the
second argument by whitespace.

Unlike shell, where you have IFS= which can change the word splitting,
make always uses white space.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
