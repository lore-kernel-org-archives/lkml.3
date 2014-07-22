Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaGVEkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:40:14 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:64666 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaGVEkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:40:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140721225153.GJ17528@sirena.org.uk>
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
 <1404303560-32209-5-git-send-email-acourbot@nvidia.com> <53B42B60.1000600@wwwdotorg.org>
 <53B4C9C0.4000605@nvidia.com> <53CD333F.2070805@wwwdotorg.org>
 <20140721211630.GA12076@mithrandir> <20140721225153.GJ17528@sirena.org.uk>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 22 Jul 2014 13:39:51 +0900
Message-ID: <CAAVeFuKtVYNP5LFXGCEpkUtCCrK6AP+9WEVPDPs45RwAPvKKRg@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: tegra: roth: add display DT node
To: Mark Brown <broonie@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 7:51 AM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Jul 21, 2014 at 11:16:32PM +0200, Thierry Reding wrote:
>> On Mon, Jul 21, 2014 at 09:35:27AM -0600, Stephen Warren wrote:
>
>> > > vdd-2v8-display needs to remain always-on however. Here we may hit a
>> > > limitation of the simple-panel driver, where only one power supply can
>> > > be provided.
>
>> > Can't we fix the simple-panel driver to allow a list of regulators in
>> > the property?
>
>> I have no objection to allowing that. But I don't think there's a way to
>> do that with the current regulator API. You can use the bulk API, but
>> that requires separate properties, not multiple regulators in one
>> property.
>
>> Perhaps one idea to solve this would be to make the regulator API return
>> a regulator handle that in fact controls an array of regulators? Adding
>> Mark.
>
> I'm really not comfortable with that idea, it seems like most of the
> users would be abusing it - one of the biggest issues is always getting
> people to understand that their driver may be used in other systems with
> the supplies mapped differently.  If you were going to do something
> along those lines you'd need to do something that enumerated all the
> supply properties on the device.

I also don't think that would do it - for many displays the power-on
sequence is not as simple as "switch all the regulators on".

Maybe what we would want is to have panel-simple allow panels to
provide a "probe" callback so they can request and manage any extra
resource they need. This would of course imply that custom
enable/disable and suspend/resume callbacks. Then the driver might not
be "simple" anymore, but IMHO it would not be that bad.
