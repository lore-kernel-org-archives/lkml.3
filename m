Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaLOGbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:31:33 -0500
Received: from mail-bn1bon0143.outbound.protection.outlook.com ([157.56.111.143]:3152
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750714AbaLOGb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:31:29 -0500
From: Dudley Du <dudl@cypress.com>
To: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        Jeremiah Mahler <jmmahler@gmail.com>
CC: "bleung@google.com" <bleung@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v15 00/12] input: cyapa: instruction of cyapa patches
Thread-Topic: [PATCH v15 00/12] input: cyapa: instruction of cyapa patches
Thread-Index: AQHQGC/AGh80EmvT/0qzqLCEbP4rNJyQL+iA
Date: Mon, 15 Dec 2014 06:31:25 +0000
Message-ID: <BN1PR06MB0701116150EACEA75FCADB7D16F0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1418624603-19054-1-git-send-email-dudley.dulixin@gmail.com>
In-Reply-To: <1418624603-19054-1-git-send-email-dudley.dulixin@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0601MB1088;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0601MB1088;
x-forefront-prvs: 04267075BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(45984002)(13464003)(51164003)(189002)(199003)(68736005)(62966003)(74316001)(102836002)(2501002)(97736003)(105586002)(106116001)(106356001)(107046002)(99286002)(122556002)(46102003)(4396001)(76576001)(40100003)(21056001)(77156002)(15975445007)(101416001)(31966008)(19580405001)(19580395003)(33656002)(66066001)(20776003)(99396003)(64706001)(50986999)(76176999)(120916001)(87936001)(54356999)(2656002)(92566001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0601MB1088;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremiah,

Thanks for your review and comments.
I have updated v15 based on your comments and suggestions.
Could you help review again please.

Thank you very much,
Dudley

> -----Original Message-----
> From: linux-input-owner@vger.kernel.org
> [mailto:linux-input-owner@vger.kernel.org] On Behalf Of Dudley Du
> Sent: 2014?12?15? 14:23
> To: dmitry.torokhov@gmail.com; rydberg@euromail.se
> Cc: Dudley Du; bleung@google.com; David Solda; linux-input@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH v15 00/12] input: cyapa: instruction of cyapa patches
>
> V15 patches have below updates, details of other updates see history list:
> 1) Fix all warning errors of sparse tool when running with "make C=1".
> 2) Change variable name "unique_str" to "product_id" for clearer meanings.
Also 3) Update cyapa_i2c_write function to return error directly when length > 31.
>
>
> This patch series is aimed to re-design the cyapa driver to support
> old gen3 trackpad devices and new gen5 trackpad devices in one
> cyapa driver, it's for easily productions support based on
> customers' requirements. And add sysfs functions and interfaces
> supported that required by users and customers.
>
> Since the earlier gen3 and the latest gen5 trackpad devices using
> two different chipsets, and have different protocols and interfaces,
> so if supported these two type trackpad devices in two different drivers,
> then it will be difficult to manage productions and later firmware updates.
> e.g.: It will cause customer don't know which one trackpad device firmware
> image to use and update when it has been used and integrated
> in same one productions, so here we support these two trackpad
> devices in same on driver.
>
> The new design cyapa driver contains:
> cyapa.c - the core of the re-design, supply interfaces and
> functions to system and read trackpad devices.
> cyapa.h - header file including macros and data structure definitions.
> cyapa_gen3.c - functions support for gen3 trackpad devices,
> cyapa_gen5.c - functions support for gen5 trackpad devices.
>
> Beside this introduction patch, it has 12 patches listed as below.
> For these patches, each one is patched based on previous one.
>
> patch 1/12: re-design cyapa driver with core functions and interface
> to support multi-type trackpad devices.
>
> patch 2/12: add gen5 trackpad device basic functions supported into the
> re-design cyapa driver.
>
> patch 3/12: add power management interfaces supported for the device.
>
> patch 4/12: add runtime power management interfaces supported for the device.
>
> patch 5/12: add sysfs interfaces supported in the cyapa driver.
> Including read firmware version, get production ID, read baseline,
> re-calibrate trackpad baselines and do trackpad firmware update.
>
> patch 6/12: add gen3 trackpad device's firmware update function supported.
>
> patch 7/12: add gen3 trackpad device's read baseline function supported.
>
> patch 8/12: add gen3 trackpad device's force re-calibrate function supported.
>
> patch 9/12: add gen5 trackpad device's firmware update function supported.
>
> patch 10/12: add gen5 trackpad device's read baseline function supported.
>
> patch 11/12: add gen5 trackpad device's force re-calibrate function.
>
> patch 12/12: add acpi device id supported.
>
>
> History patch series modifications list:
> V14 patches have below main updates compared with v13 patches:
> 1) Correct 9 miss spelling issues of "bufferred" to "buffered".
> 2) Fix the upgrade issue of removing MOUSE_CYAPA config when make oldconfig
>    by replase "depends on I2C && CRC_ITU_T" with
> "depends on I2C"
> "select CRC_ITU_T"
>    in patch 9.
>
> V13 patches have below main updates compared with v12 patches:
> 1) Remove all debugfs interface, including read_fw and raw_data interfaces.
> 2) This patches are made based linux next-20141208.
>
> V12 patches have below main updates compared with v11 patches:
> 1) Add check that when TP is detected but not operational, do not exit driver
>    immediately, but wait and export the update_fw interface for recovering.
> 2) Re-arrange the function codes, remove unnesseary protype definitions in
>    the header file.
>
> V11 patches have below main updates compared with v10 patches:
> 1) Add add acpi device id supported for old gen3 and new gen5 trackpad devices.
> 2) Fix the unable to update firmware issue when cyapa_open is not called
>    which means the irq for firwmare update process is not enabled. This fix
>    by checking if the irq is enabled, if not then enable irq before start to
>    do firmware update.
>
> V10 patches have below main updates compared with v9 patches:
> 1) Modify code to following kernel code style.
>    e.g.: correct to use error as return name when there is only error path,
>    and fix the checkpatch.sh wanting in the driver.
> 2) Remove cyapa_remove method and use input open and close interface to
>    following device resouse management infrastructure.
> 3) Modify cyapa_detect method to return tristate issue to make the return value
>    much more consistent and clear.
> 4) Use platform supplied functions as possible instead of driver
>    specific rewritten version.
>
> V9 patches have below updates compared with v8 patches:
> 1) Removed all async thread stuff from the driver.
> 2) Split driver into 18 patches for each function change one patch.
>
> V8 patches have below updates compared with v7 patches:
> 1) [PATCH v8 01/13] - Remove the async thread for device detect in
>    probe routine, now the device detect process is completely done within
>    the device probe routine.
> 2) [PATCH v8 01/13] - Split the irq cmd hander function to separated
>    function cyapa_default_irq_cmd_handler() and set it to interface
>    cyapa_default_ops.irq_cmd_handler.
> 3) [PATCH v8 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
>    to avoid miss-enter when device protocol is still in detecting.
>
> V7 patches have below updates compared with v6 patches:
> 1) [PATCH v7 01/13] - Split the irq cmd hander function to separated
>    function cyapa_default_irq_cmd_handler() and set it to interface
>    cyapa_default_ops.irq_cmd_handler.
> 2) [PATCH v7 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
>    to avoid miss-enter when device protocol is still in detecting.
>
>
> V6 patches have below updates compared with v5 patches:
> 1) Remove patch 14 of the lid filtering from the cyapa driver.
>
> V5 patches have below updates compared with v4 patches:
> 1) Uses get_device()/put_device() instead of kobject_get()/kobject_put();
> 2) Fix memories freed before debugfs entries issue;
> 3) Make cyapa_debugs_root valid in driver module level
>    in module_init()/moudle_exit() ;
> 4) Fix i2c_transfer() may return partial transfer issues.
> 5) Add cyapa->removed flag to avoid detecting thread may still running
>    when driver module is removed.
> 6) Fix the meanings of some comments and return error code not clear issue.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
