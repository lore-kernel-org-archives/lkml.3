Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422756Ab3BGWet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:34:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422730Ab3BGWes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:34:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [char-misc-next 03/11] mei: bus: Initial implementation for I/O routines
Date: Thu, 7 Feb 2013 22:34:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <1360270997-7639-4-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1360270997-7639-4-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072234.44181.arnd@arndb.de>
X-Provags-ID: V02:K0:D3I10G0QDjxIp7oINcYzNDxSugXf7G8+KksePZRYPuh
 JLfS7x0W+ArQHo8yao14ALm4DxutJZysz4v/teIsGQdcAWOkFa
 Gj0H3K61EEM0L+AWkJKy0BnYR74nh3aX5KkQMCrlS72qxU4l6U
 Hgf41TUqrXtkRWDhc+vL0tJ8nOb3CgnlDoUd2BXxxNQfHaBAvP
 CpRRWdvQn5Pb5CoPKfggusE2CYLK/5jOF47TswkkqDH9gjRr3z
 V9XwJnFI9W4c+Wh95Q0Hr60SD+nfYMdc1iB4GNW1CsOXZGPHYg
 eqyE2SAIZYr2M3N6H9P9TtrrlGWi8JUfSSVLWZmzrivQFIzufq
 QaRAY+zwPC0K77b+iKPg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Tomas Winkler wrote:
> +
> +struct mei_bus_ops {
> +       int (*send)(struct mei_bus_client *client, u8 *buf, size_t length);
> +       int (*recv)(struct mei_bus_client *client, u8 *buf, size_t length);
> +};
> +

Can you have more than one set of mei_bus_ops in a driver? If not,
how about adding the callbacks to the mei_bus_driver structure
directly as a simplification? Never mind if that doesn't work for
some obvious reason I missed.

	Arnd
