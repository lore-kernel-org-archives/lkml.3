Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaKEVqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:46:39 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:50574 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaKEVqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:46:35 -0500
MIME-Version: 1.0
In-Reply-To: <545912D2.5090708@codeaurora.org>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAOZdJXXAQtmR_Wq194nbiEpg2TYS7_5tXhLtDWckD4xMHGkdZg@mail.gmail.com>
 <20141104082056.GG1618@lahna.fi.intel.com> <545912D2.5090708@codeaurora.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 5 Nov 2014 21:46:14 +0000
X-Google-Sender-Auth: P3JFkDURXSrxLO6imkAB3DnbWuY
Message-ID: <CACxGe6t=nK83pGNDKmZJ28BZJqgNjGZgckrzVrBiFko1AcT0xg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
To: Timur Tabi <timur@codeaurora.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 5:54 PM, Timur Tabi <timur@codeaurora.org> wrote:
> On 11/04/2014 02:20 AM, Mika Westerberg wrote:
>>
>> There is nothing like that yet in ACPI world but with the ACPI _DSD
>> patches we are getting properties similar to DT which means that we can
>> provide pinctrl bindings from ACPI systems as well.
>
>
> Do you know if anyone has signed up to actually do the work of defining how
> pinctrl will look in ACPI?  I'm guessing the simplest approach would be to:

Actually, for the most part we /don't/ want to try and put pinctrl
into an ACPI binding. The assumption is that on an ACPI platform it
would be the combination of ACPI and firmware responsible for the pin
mappings, not the operating system.

Before even attempting to put pinctrl mappings into your driver, there
should instead be a conversation at the ACPI spec level about whether
or not it makes sense and what such a binding should look like.

g.
