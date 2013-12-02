Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3LBTHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:07:43 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38768 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab3LBTHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:07:35 -0500
Date: Mon, 2 Dec 2013 11:07:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Manuel Krause <manuelkrause@netscape.net>
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linux-input@vger.kernel.org,
        linux-serial <linux-serial@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: 3.12.x looses serial mouse over hibernate + resume
Message-ID: <20131202190730.GA5245@core.coreip.homeip.net>
References: <52951E69.7090602@netscape.net>
 <529B591F.1020909@hurleysoftware.com>
 <529CB07C.2040609@netscape.net>
 <19253701.sgP3OieFUq@dtor-d630.eng.vmware.com>
 <20131202164525.GA32406@core.coreip.homeip.net>
 <529CD303.4040103@netscape.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529CD303.4040103@netscape.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 07:35:47PM +0100, Manuel Krause wrote:
> On 2013-12-02 17:45, Dmitry Torokhov wrote:
> >On Mon, Dec 02, 2013 at 08:38:16AM -0800, Dmitry Torokhov wrote:
> >>On Monday, December 02, 2013 05:08:28 PM Manuel Krause wrote:
> >>>On 2013-12-01 16:43, Peter Hurley wrote:
> >>>>[ +cc Dmitry Torokhov, Greg Kroah-Hartman, linux-input,
> >>>>linux-serial ]
> >>>>
> >>>>On 11/26/2013 05:19 PM, Manuel Krause wrote:
> >>>>>Since kernel 3.12.0 I have a problem with hibernate+resume
> >>>>>not reactivating my serial mouse (trackball) with my HP notebook.
> >>>>>Kernels 3.11.0 til 9 don't show this behaviour.
> >>>>>
> >>>>>Machine:           HP Notebook with Core2Duo CPU (Penryn)
> >>>>>Distro:            openSUSE 12.3, 64bit, continuously updated
> >>>>>Desktop:           KDE 4.11.3
> >>>>>MESA & drm & Xorg: most recent ones from:
> >>>>>
> >>>>>http://download.opensuse.org/repositories/home:/pontostroy:/X11/openSUSE_
> >>>>>12.3/x86_64/
> >>>>>
> >>>>>Current kernel:    3.12.1 vanilla from openSUSE repos, with
> >>>>>
> >>>>>                     -ck1 and BFQ patches
> >>>>>
> >>>>>The Logitech Trackman Marble FX is a PS/2 device and connected
> >>>>>via an original Logitech
> >>>>>PS/2-COM-port adapter and manually configured via my xorg.conf.
> >>>>>
> >>>>>At first, I blamed the -ck1 patches from Con Kolivas for this
> >>>>>behaviour that I use in
> >>>>>addition  to the BFQ patches, what has showed up as not right:
> >>>>>This happens with the
> >>>>>normal vanilla kernel
> >>>>>schedulers for CPU and disk I/O, too.
> >>>>>
> >>>>>By coincidence I found a weird(!) way to reactivate the serial
> >>>>>mouse:
> >>>>>(1) call Hibernate (suspend-to-disk) from KDE desktop as normal
> >>>>>(2) resume --> the PS/2 touchpad is working, the serial
> >>>>>trackball NOT
> >>>>>(3) call suspend-to-RAM (Sleep) from KDE, serial trackball
> >>>>>still dead
> >>>>>(4) execute `setserial -a /dev/ttyS0` in a konsole window or a
> >>>>>tty* console
> >>>>>(5) ==> serial trackball is back with all configuration from
> >>>>>xorg.conf
> >>>>>
> >>>>>It's fully reproducible over multiple hibernations. This also
> >>>>>happens when calling
> >>>>>`pm-hibernate` (to-disk) and `pm-suspend` (to-RAM) and the
> >>>>>setserial from a root shell
> >>>>>in KDE or any tty*.
> >>>>>
> >>>>>Please, _always_CC_me_ -- as I'm not on the kernel mailing list.
> >>>>
> >>>>Manuel,
> >>>>
> >>>>Please attach complete dmesgs (zipped, if necessary) of a
> >>>>suspend/resume cycle
> >>>>on a vanilla 3.12.x (where resume fails) _and_ a vanilla 3.11.x
> >>>>(where resume succeeds).
> >>>>
> >>>>For the test configurations, please do not apply patches.
> >>>>
> >>>>Regards,
> >>>>Peter Hurley
> >>>
> >>>Thank you very much for your reply!
> >>>Attached you'll find a zip file with the two edited dmesg logs of
> >>>plain vanilla kernel runs.
> >>>
> >>>I have to add, that the resumes _do_ succeed in both cases, only
> >>>the serial mouse doesn't get activated after hibernate in 3.12.x
> >>>automatically. Just scan for and compare the lines indicating
> >>>"serial 00:08: disabled" or "serial 00:08: activated". In 3.12.x
> >>>the activation doesn't happen after hibernate, but after
> >>>suspend-to-ram (sleep). That only after STR and not before a
> >>>setserial gets my mouse back... a miracle. ;-)
> >>
> >>I do not see
> >>
> >>>[  206.577370] serial 00:08: activated
> >>
> >>in the restore from hibernation log of 3.12 which shoudl come from PNP
> >>layer.
> >>
> >>[dtor@dtor-d630 work]$ git log --oneline v3.11..v3.12 -- drivers/pnp/
> >>729377d pnp: change pnp bus pm_ops to invoke pnp driver dev_pm_ops if specified
> >>ce63e18 Merge branch 'pnp'
> >>8ad928d ACPI / PM: Use ACPI_STATE_D3_COLD instead of ACPI_STATE_D3 everywhere
> >>eaf140b PNP: convert PNP driver bus legacy pm_ops to dev_pm_ops
> >>
> >>I'd start looking into these commits.
> >>
> >
> >Does the following patch fixes the issue?
> >
> 
> PNP: fix restoring devices after hibernation
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> On returning from hibernation 'restore; callback is called, not
> 'resume'.
> This fixes breakage introduced by commit
> eaf140b60ec961252083ab8adaf67aef29a362dd
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/pnp/driver.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
> index a39ee38..185a24a 100644
> --- a/drivers/pnp/driver.c
> +++ b/drivers/pnp/driver.c
> @@ -235,8 +235,9 @@ static int pnp_bus_resume(struct device *dev)
> 
>  static const struct dev_pm_ops pnp_bus_dev_pm_ops = {
>  	.suspend = pnp_bus_suspend,
> -	.freeze = pnp_bus_freeze,
>  	.resume = pnp_bus_resume,
> +	.freeze = pnp_bus_freeze,
> +	.restore = pnp_bus_resume,
>  };
> 
>  struct bus_type pnp_bus_type = {
> 
> 
> YES! This patch fixes the issue!!! (Even if compiled with a patched
> kernel.)   ;-)
> 
> Many thanks for your work!
> 

Thank you Manuel, but IO think the patch is not complete as we need to
re-enable PNP devices after we make a snapshot to make sure they are
working and can handle saving the data. Coudl you please try the patch
below?

-- 
Dmitry


PNP: fix restoring devices after hibernation

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

On returning from hibernation 'restore; callback is called, not 'resume'.
This fixes breakage introduced by commit
eaf140b60ec961252083ab8adaf67aef29a362dd

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/pnp/driver.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index a39ee38..2bd5c5f 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -197,6 +197,11 @@ static int pnp_bus_freeze(struct device *dev)
 	return __pnp_bus_suspend(dev, PMSG_FREEZE);
 }
 
+static int pnp_bus_poweroff(struct device *dev)
+{
+	return __pnp_bus_suspend(dev, PMSG_HIBERNATE);
+}
+
 static int pnp_bus_resume(struct device *dev)
 {
 	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
@@ -234,9 +239,14 @@ static int pnp_bus_resume(struct device *dev)
 }
 
 static const struct dev_pm_ops pnp_bus_dev_pm_ops = {
+	/* Suspend callbacks */
 	.suspend = pnp_bus_suspend,
-	.freeze = pnp_bus_freeze,
 	.resume = pnp_bus_resume,
+	/* Hibernate callbacks */
+	.freeze = pnp_bus_freeze,
+	.thaw = pnp_bus_resume,
+	.poweroff = pnp_bus_poweroff,
+	.restore = pnp_bus_resume,
 };
 
 struct bus_type pnp_bus_type = {
