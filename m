Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbaKUIOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 03:14:34 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42901 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162AbaKUIOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:14:33 -0500
Message-ID: <546EF464.5060109@gmail.com>
Date: Fri, 21 Nov 2014 09:14:28 +0100
From: Harald Hoyer <harald.hoyer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
        ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
        jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: kdbus: add code for buses, domains and endpoints
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-10-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1416546149-24799-10-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.11.2014 06:02, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel@zonque.org>
> 
> Add the logic to handle the following entities:
> 
> Domain:
>   A domain is an unamed object containing a number of buses. A
>   domain is automatically created when an instance of kdbusfs
>   is mounted, and destroyed when it is unmounted.
>   Every domain offers its own "control" device node to create
>   buses.  Domains have no connection to each other and cannot
>   see nor talk to each other.
> 
> Bus:
>   A bus is a named object inside a domain. Clients exchange messages
>   over a bus. Multiple buses themselves have no connection to each
>   other; messages can only be exchanged on the same bus. The default
>   entry point to a bus, where clients establish the connection to, is
>   the "bus" device node /dev/kdbus/<bus name>/bus.  Common operating
>   system setups create one "system bus" per system, and one "user
>   bus" for every logged-in user. Applications or services may create
>   their own private named buses.

might need a resync with the documentation.

Bus:
  A bus is a named object inside a domain. Clients exchange messages
  over a bus. Multiple buses themselves have no connection to each other;
  messages can only be exchanged on the same bus. The default entry point to
  a bus, where clients establish the connection to, is the "bus" file
  /sys/fs/kdbus/<bus name>/bus.
  Common operating system setups create one "system bus" per system, and one
  "user bus" for every logged-in user. Applications or services may create
   their own private named buses. See section 5 for more details.


