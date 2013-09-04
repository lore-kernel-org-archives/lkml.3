Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab3IDSoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:44:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55708 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3IDSof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:44:35 -0400
Message-ID: <52277F90.40109@wwwdotorg.org>
Date: Wed, 04 Sep 2013 12:44:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>
CC: thierry.reding@gmail.com, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] host1x: hdmi: Enable Vdd earlier for hotplug/DDC
References: <1377704922-2824-1-git-send-email-mperttunen@nvidia.com> <1377704922-2824-4-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1377704922-2824-4-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 09:48 AM, Mikko Perttunen wrote:
> The Vdd regulator used to be enabled only at tegra_output_hdmi_enable,
> which is called after a sink is detected. However, the HDMI hotplug pin
> works by returning the voltage supplied by the Vdd pin, so this meant
> that the hotplug pin was never asserted and the sink was not detected
> unless the Vdd regulator was set to be always on.
> 
> This patch moves the enable to the tegra_hdmi_drm_init function to make
> sure the regulator will get enabled.

The DT binding document isn't very clear on this topic (and should be
fixed): What is this regulator intended to control? If this regulator
solely controls the supply to the hotplug detection circuit, this change
makes sense. If the regulator mainly supplies something else (e.g. part
of the HDMI core on the Tegra chip), then perhaps this change isn't
correct. The correct approach might be to introduce another (optional)
regulator specifically for the hotplug circuit. Presumably both DT
properties vdd-supply and hotplug-supply could point at the same
regulator if that's the way the HW was wired up.
