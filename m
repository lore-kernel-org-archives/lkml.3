Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaATXgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:36:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58382 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbaATXgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:36:09 -0500
Date: Mon, 20 Jan 2014 23:35:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@kernel.org>, Tushar Behera <tushar.behera@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
Message-ID: <20140120233541.593d0918@www.etchedpixels.co.uk>
In-Reply-To: <20140120232141.GM15937@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
	<1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
	<20140120100530.GY15937@n2100.arm.linux.org.uk>
	<CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
	<20140120214305.54f65ffa@www.etchedpixels.co.uk>
	<20140120231457.GZ17314@sirena.org.uk>
	<20140120232141.GM15937@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The first bit is easy... but we need to add locks to every serial
> driver to prevent two probes operating concurrently...

The bus probe should already be serializing surely ?

 
