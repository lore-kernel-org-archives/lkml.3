Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3I0PUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:20:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57353 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729Ab3I0PUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:20:41 -0400
X-Sasl-enc: BlWRTnj6PNSe+gTchkOQvlDqq8nkzGCTDRXoiLY8ln99 1380295238
Date: Fri, 27 Sep 2013 12:20:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: Re: [PATCH v3 4/4] thinkpad-acpi: fix handle locate for video and
 query of _BCL
Message-ID: <20130927152035.GB4140@khazad-dum.debian.net>
References: <1380016052-15315-1-git-send-email-aaron.lu@intel.com>
 <1380016052-15315-5-git-send-email-aaron.lu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380016052-15315-5-git-send-email-aaron.lu@intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013, Aaron Lu wrote:
> The tpacpi_acpi_handle_locate function makes use of acpi_get_devices to
> locate handle for ACPI video by HID, the problem is, ACPI video node
> doesn't really have HID defined(i.e. no _HID control method is defined
> for video device), so.. that function would fail. This can be solved by
> enhancing the callback function for acpi_get_devices, where we can use
> acpi_device_hid function to check if the ACPI node corresponds to a
> video controller.
> 
> In addition to that, the _BCL control method only exists under a video
> output device node, not a video controller device node. So to evaluate
> _BCL, we need the handle of a video output device node, which is child
> of the located video controller node from tpacpi_acpi_handle_locate.
> 
> The two fix are necessary for some Thinkpad models to emit notification
> on backlight hotkey press as a result of evaluation of _BCL.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>

Some testing on a *60 (T60,X60...) would also be best, I cannot test this on
my T43.

Anyway, the code itself looks fine, so:

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
