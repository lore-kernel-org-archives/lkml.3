Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbaJ1Wev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:34:51 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:46406 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbaJ1Wet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:34:49 -0400
Date: Tue, 28 Oct 2014 22:34:35 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Skidanov, Alexey" <Alexey.Skidanov@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 32 bit user space compatibility
Message-ID: <20141028223435.73b3778c@alan.etchedpixels.co.uk>
In-Reply-To: <AD975D71AAD7784D8D1265DF6444C2FD0C4307FC@storexdag03.amd.com>
References: <AD975D71AAD7784D8D1265DF6444C2FD0C4307FC@storexdag03.amd.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2014 12:25:08 +0000
"Skidanov, Alexey" <Alexey.Skidanov@amd.com> wrote:

> Hi,
> 
> Running 32 bit user space needs some work to be done with ioctls. I understand that there are two options to implement:
> 1.       Use only fixed size types. Pad IOCTLS params to multiple of 64 bits - simple; don't know if it covers all compatibility issues; 
> 2.       32 bit compatibility layer (through compat_ioctl, just like many drivers in kernel implement)  - just a little bit simple code with some translations; really covers all issues;
>  
> Which one is preferred by kernel community?

You shouldn't need to pad paramters in most cases as platform alignment
rules are usually sane for 32 and 64bit. #1 is preferred. #2 exists
because 64bit appeared after Linux was designed so it wasn't designed in
from day one.
