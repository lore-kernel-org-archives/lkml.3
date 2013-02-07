Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422796Ab3BGWlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:41:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58078 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422744Ab3BGWlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:41:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [char-misc-next 01/11] mei: bus: Initial MEI bus type implementation
Date: Thu, 7 Feb 2013 22:41:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <1360270997-7639-2-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1360270997-7639-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072241.07171.arnd@arndb.de>
X-Provags-ID: V02:K0:xWj3S2har+gxKi8cQPALM7gpSYIofGF1Ajy5vvqFS2J
 YaivAxbuJgVi1UccKK7Rsb3UkpIZ9F2HDJP2QEzOxWiDHQwGMU
 4i5jGmFxU9tWyErWbjYHdvbwUn4fm6N2CmiLD1kxVPpFnelrPV
 n8QuhRrfRWeeJKNXGOMXs6vH7ZuELYAVmS1pLApzSe0vlekIa1
 kix6RXp/ScaJRUstJNkz8w2u6kiX2qWv2ulMiV85Wa/Yzf+EZ5
 8A6Gmf3NlYiRH81RYQmRmLsiCWYssgd9r/A3C7k+pWtfBUubhy
 LiK1XEHYF4BjYyIZenOgTUDz7stXxvtk7Cops7+kXw4xAlC6WG
 9k3HOb2r9njOINcVwnGY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Tomas Winkler wrote:
> +}
> +EXPORT_SYMBOL(mei_add_device);
> +
> +void mei_remove_device(struct mei_bus_client *client)
> +{
> +       device_unregister(&client->dev);
> +}
> +EXPORT_SYMBOL(mei_remove_device);

One more point: did you intentionally pick EXPORT_SYMBOL over
EXPORT_SYMBOL_GPL here? It is your decision as the copyright
holder, but the default is often EXPORT_SYMBOL_GPL these
days, to make it clear that you don't expect closed source
drivers to plug in there.

	Arnd
