Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3DMIAQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 04:00:16 -0400
Received: from smtp-out-232.synserver.de ([212.40.185.232]:1027 "EHLO
	smtp-out-232.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3DMIAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 04:00:14 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5148
Message-ID: <51691053.7060707@metafoo.de>
Date: Sat, 13 Apr 2013 09:59:15 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: drivers/base/core.c: about device_find_child() function
References: <3798489.yISokZugC2@harkonnen> <20130411134844.GA3489@kroah.com> <2849474.HO2K6X9Bdi@harkonnen>
In-Reply-To: <2849474.HO2K6X9Bdi@harkonnen>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 02:09 PM, Federico Vaga wrote:
> [...]
> 
> [**] (argumentation based, obviously, on my limited understanding)
> 
> These drivers work like this:
> 
> 	child = device_find_child(parent, data, match_function);
> 	if (child) {
> 		put_device(child);		
> 		<do something unrelated with child> 
> 	}
> 
> In these cases we do not need to get_device(). But we need to know if there 
> is a child that match a rule. It can also "disapper" after the
> put_device(child) but the driver continues on its way because it does not
> use the child. For example virtio_rpmsg_bus.c:
> 
> 	/* make sure a similar channel doesn't already exist */
> 	tmp = device_find_child(dev, chinfo, rpmsg_channel_match);
> 	if (tmp) {
> 		/* decrement the matched device's refcount back */
> 		put_device(tmp);
> 		dev_err(dev, "channel %s:%x:%x already exist\n",
> 				chinfo->name, chinfo->src, chinfo->dst);
> 		return NULL;
> 	}

Considering that there seems to be a common pattern here where the caller
only wants to know if the device exists, but is not really interested in the
device itself, how about adding a helper function for this?

- Lars
