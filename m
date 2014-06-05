Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaFEVNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:13:44 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:59577 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaFEVNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:13:41 -0400
MIME-Version: 1.0
In-Reply-To: <3417.1402002643@turing-police.cc.vt.edu>
References: <18529.1401981749@turing-police.cc.vt.edu>
	<CAA9_cmfje+8qAh7NqjHi1zcRAPZgJ0xdOK2nM7TKN9NRgqcRfw@mail.gmail.com>
	<23223.1401985468@turing-police.cc.vt.edu>
	<CAPcyv4gYnvF4Nt5itkDsD=DzL8sfETZUBmQqZwiHE1SOZvtsbw@mail.gmail.com>
	<33745.1401989394@turing-police.cc.vt.edu>
	<1401995156.30026.2.camel@dwillia2-mobl2.amr.corp.intel.com>
	<3417.1402002643@turing-police.cc.vt.edu>
Date: Thu, 5 Jun 2014 14:13:41 -0700
Message-ID: <CAPcyv4iK-u1512jFgwsaXke_jjew0US6Wc=pM5Wm0tfEw9_b_g@mail.gmail.com>
Subject: Re: linux-next crash in xhci_add_ep_to_interval
From: Dan Williams <dan.j.williams@intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 2:10 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 05 Jun 2014 12:05:56 -0700, Dan Williams said:
>
>> Subject: usb: fix ->update_hub_device() vs hdev->maxchild
>>
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> Commit d8521afe3586 "usb: assign default peer ports for root hubs"
>> delayed marking a hub valid (set hdev->maxchild) until it had been fully
>> configured and to enable the publishing of valid hubs to be serialized
>> by usb_port_peer_mutex.
>>
>> However, xhci_update_hub_device() in some cases depends on
>> hdev->maxchild already being set.  Do the minimal fix and move it after
>> the setting of hdev->maxchild.
>>
>> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Applied cleanly, booted without complaint, the keyboard that's behind
> the PS2-USB converter works.
>
> uname -r reports 3.15.0-rc8-next-20140605-dirty as expected.
>
> So feel free to stick a Tested-By: on there. :)

Thank you, much appreciated!
