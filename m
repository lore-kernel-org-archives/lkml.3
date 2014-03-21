Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbaCUNvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:51:06 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39336 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaCUNvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:51:02 -0400
Message-ID: <532C4515.3040500@gmail.com>
Date: Fri, 21 Mar 2014 14:56:37 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Rob Herring <robherring2@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Subject: Re: [PATCH v3 3/7] OF: DT-Overlay configfs interface
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com> <1395179766-31575-4-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqKJqakXGWDEKPAoJ9P5myYXnodcYCdvowV6MPuZXgwVmw@mail.gmail.com>
In-Reply-To: <CAL_JsqKJqakXGWDEKPAoJ9P5myYXnodcYCdvowV6MPuZXgwVmw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 02:39 PM, Rob Herring wrote:
> On Tue, Mar 18, 2014 at 4:56 PM, Pantelis Antoniou
> <pantelis.antoniou@konsulko.com> wrote:
>> Add a runtime interface to using configfs for generic device tree overlay
>> usage.
>>
>> A device-tree configfs entry is created in /config/device-tree/overlays
>>
>> To create an overlay you mkdir the directory and then echo the overlay
>> firmware file to the path property file.
>>
>>          # mkdir /config/device-tree/overlays/foo
>>          # echo foo.dtbo >/config/device-tree/overlays/foo/path
[...]
>> +static ssize_t cfs_overlay_item_status_show(struct cfs_overlay_item *overlay,
>> +               char *page)
>> +{
>> +       return sprintf(page, "%s\n",
>> +                       overlay->applied ? "applied" : "unapplied");
>> +}
>
> This needs to be added to the above mentioned documentation along with
> any other files.

It is also terrible to grep for. Maybe just have the file named
"applied" and use a bool instead?

Sebastian

>> +
>> +CFS_OVERLAY_ITEM_ATTR(path, S_IRUGO | S_IWUSR, \
>> +               cfs_overlay_item_path_show, cfs_overlay_item_path_store);
>> +CFS_OVERLAY_ITEM_ATTR_RO(status, cfs_overlay_item_status_show);
>> +
>> +static struct configfs_attribute *cfs_overlay_attrs[] = {
>> +       &cfs_overlay_item_attr_path.attr,
>> +       &cfs_overlay_item_attr_status.attr,
>> +       NULL,
>> +};

