Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbbAYQTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:19:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbbAYQPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:49 -0500
Date: Sun, 25 Jan 2015 20:39:42 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>
Subject: Re: [PATCH char-misc-next v2 01/13] misc: mic: SCIF header file and
 IOCTL interface
Message-ID: <20150125123942.GA21763@kroah.com>
References: <cover.1421097390.git.sudeep.dutt@intel.com>
 <8ff5b107eeabad618e07c156ec541409b9f88c6a.1421097390.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ff5b107eeabad618e07c156ec541409b9f88c6a.1421097390.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:09:55PM -0800, Sudeep Dutt wrote:
> --- /dev/null
> +++ b/include/uapi/linux/scif_ioctl.h
> @@ -0,0 +1,213 @@
> +/*
> + * Intel MIC Platform Software Stack (MPSS)
> + *
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + * redistributing this file, you may do so under either license.
> + *
> + * GPL LICENSE SUMMARY
> + *
> + * Copyright(c) 2014 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * BSD LICENSE
> + *
> + * Copyright(c) 2014 Intel Corporation.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + * * Redistributions of source code must retain the above copyright
> + *   notice, this list of conditions and the following disclaimer.
> + * * Redistributions in binary form must reproduce the above copyright
> + *   notice, this list of conditions and the following disclaimer in
> + *   the documentation and/or other materials provided with the
> + *   distribution.
> + * * Neither the name of Intel Corporation nor the names of its
> + *   contributors may be used to endorse or promote products derived
> + *   from this software without specific prior written permission.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
> + * Intel SCIF driver.
> + *
> + */
> +/*
> + * -----------------------------------------
> + * SCIF IOCTL interface information
> + * -----------------------------------------
> + */
> +#ifndef SCIF_IOCTL_H
> +#define SCIF_IOCTL_H
> +
> +/**
> + * struct scif_port_id - SCIF port information
> + * @node:	node on which port resides
> + * @port:	local port number
> + */
> +struct scif_port_id {
> +	uint16_t node;
> +	uint16_t port;

variables that cross the kernel/user interface need to use the __*
types, so these would be __u16.  Please fix up all of these structures
in this file.


> +};
> +
> +/**
> + * struct scifioctl_connect - used for SCIF_CONNECT IOCTL
> + * @self:	used to read back the assigned port_id
> + * @peer:	destination node and port to connect to
> + */
> +struct scifioctl_connect {
> +	struct scif_port_id	self;
> +	struct scif_port_id	peer;
> +};
> +
> +/**
> + * struct scifioctl_accept - used for SCIF_ACCEPTREQ IOCTL
> + * @flags:	flags
> + * @peer:	global id of peer endpoint
> + * @endpt:	new connected endpoint descriptor
> + */
> +struct scifioctl_accept {
> +	int			flags;

int?  Please be specific of your types for ioctls.

thanks,

greg k-h
