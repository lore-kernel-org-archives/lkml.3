Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3LaXXu (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 18:23:50 -0500
Received: from senator.holtmann.net ([87.106.208.187]:53647 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab3LaXXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 18:23:49 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20131231221202.GB25336@amd.pavel.ucw.cz>
Date: Tue, 31 Dec 2013 15:23:36 -0800
Cc: =?windows-1252?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <E7C15C38-8E0E-4D49-9E93-5E3DAF77E252@holtmann.org>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com> <1727897.LBX8128hIo@izba> <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org> <20131231221202.GB25336@amd.pavel.ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>>> +static struct task_struct *h4p_thread;
>> 
>> Can’t this be done using a work queue. You are looking at a 3.14
>> kernel the earliest. We have way better primitives these days.
> 
> I tried to convert it to work queue, but was not too
> succesfull. Workqueue is not really good match for what this is trying
> to do... Nokia code relies on sleeping, than timing those sleeps for
> signaling. I'm still trying to wrap my head around it.
> 
> Ok, I guess I could convert it to one big workqueue task, and leave
> the logic alone. Was that what you wanted?

the Bluetooth subsystem moved away from tasklets and uses workqueues for everything. So this should be just fine for this driver as well. I do not know about what timings are required, but they should only matter during initial device setup. The HCI traffic is actually driven by the Bluetooth core.

Regards

Marcel

