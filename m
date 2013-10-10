Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3JJOS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:18:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:44632 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab3JJOSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:18:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1072,1371106800"; 
   d="png'150?scan'150,208,150";a="414895599"
Date: Thu, 10 Oct 2013 07:18:18 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] tools/thermal: Introduce tmon, a tool for thermal
 subsystem
Message-ID: <20131010071818.000a9397@ultegra>
In-Reply-To: <5255E8A4.6030400@ti.com>
References: <1381259024-25433-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<5254AB6A.1090600@ti.com>
	<20131009105217.0b23a6c3@ultegra>
	<5255E8A4.6030400@ti.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/yKBLsnwj0BUM2MJMYPxJTHF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/yKBLsnwj0BUM2MJMYPxJTHF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, 9 Oct 2013 19:37:08 -0400
Eduardo Valentin <eduardo.valentin@ti.com> wrote:

> On 09-10-2013 13:52, Jacob Pan wrote:
> > On Tue, 8 Oct 2013 21:03:38 -0400
> > Eduardo Valentin <eduardo.valentin@ti.com> wrote:
> >=20
> >> On 08-10-2013 15:03, Jacob Pan wrote:
> >>> Increasingly, Linux is running on thermally constrained devices.
> >>> The simple thermal relationship between processor and fan has
> >>> become past for modern computers.
> >>>
> >>> As hardware vendors cope with the thermal constraints on their
> >>> products, more sensors are added, new cooling capabilities are
> >>> introduced. The complexity of the thermal relationship can grow
> >>> exponentially among cooling devices, zones, sensors, and trip
> >>> points. They can also change dynamically.
> >>>
> >>> To expose such relationship to the userspace, Linux generic
> >>> thermal layer introduced sysfs entry at /sys/class/thermal with a
> >>> matrix of symbolic links, trip point bindings, and device
> >>> instances. To traverse such matrix by hand is not a trivial task.
> >>> Testing is also difficult in that thermal conditions are often
> >>> exception cases that hard to reach in normal operations.
> >>>
> >>> TMON is conceived as a tool to help visualize, tune, and test the
> >>> complex thermal subsystem.
> >>
> >> Jacob,
> >>
> >> Very nice initiative. Thanks for providing tools on thermal area.
> >> We are lacking them. I have been using the linaro thermal testing
> >> scripts for smoking testing the systems I am working on. But I have
> >> been considering writing a ncurses based tool for long time. It is
> >> good anyway that you have started and even shared it already.
> >>
> >> I gave a very quick shot on my OMAP4460 panda board and tmon is
> >> crashing with segfault:
> >>>     TMON v1.0
> >>>
> >>> =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> >>> =E2=94=82Thermal Zones:
> >>> cpu_therm00                                    =E2=94=82 =E2=94=82Trip
> >>> Points:
> >>> CP                                             =E2=94=82
> >>> =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >>> =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> >>> =E2=94=82ID  Cooling Dev   Cur    Max   Thermal Zone
> >>> Binding                           =E2=94=82 =E2=94=8200 thermal-cpuf =
    0      3
> >>> Segmentation fault                             =E2=94=82
> >>> =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80[root@(none) ~]#
> >>> =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98 [root@(none) ~]# ./tmontmon
> >>> =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=90
> >>> =E2=94=82                         10        20        30        40
> >>> 50        60 =E2=94=82 =E2=94=82cpu_th
> >>> 0:[  0][>
> >>> =E2=94=82
> >>> =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >>>
> >>>
> >>
> >> I believe it is while updating the progress bar you've written to
> >> represent temperature on the thermal zone temperature.
> >>
> > Sorry about the crash, I admit i only tested on x86 systesm. I just
> > borrowed a Panda board. Could you tell me where you get the image to
> > run it on?
>=20
> I am using a busybox based filesystem. And I have statically compiled
> tmon. It is against 3.12-rc1.
>=20
oh, I have a ubuntu image on the panda board. I guess the kernel is
old so the sensors do not show even when i enabled the following
options.
CONFIG_SENSORS_OMAP_TEMP_SENSOR=3Dy
CONFIG_OMAP_THERMAL=3Dy

what are the kernel options to enable OMAP thermal?
> >=20
> > At the same time, could you help me debug with showing me the
> > result of " tree -l -L 2 /sys/class/thermal/"
>=20
> I tried also on my x86 dell laptop. I gave up on this track to because
> tmon does not progress when there is no thermal zone.
> ebv@besouro:/sys/class/thermal$
> $ tree
> .
> =E2=94=9C=E2=94=80=E2=94=80 cooling_device0 -> ../../devices/virtual/ther=
mal/cooling_device0
> =E2=94=9C=E2=94=80=E2=94=80 cooling_device1 -> ../../devices/virtual/ther=
mal/cooling_device1
> =E2=94=9C=E2=94=80=E2=94=80 cooling_device2 -> ../../devices/virtual/ther=
mal/cooling_device2
> =E2=94=9C=E2=94=80=E2=94=80 cooling_device3 -> ../../devices/virtual/ther=
mal/cooling_device3
> =E2=94=94=E2=94=80=E2=94=80 cooling_device4 -> ../../devices/virtual/ther=
mal/cooling_device4
>=20
> 5 directories, 0 files
>=20
> The only problem is that tmon exists silently. I would be nice to have
> at least a message saying why it is not continuing.
>=20
I will fix that in the next version. also attached a screen shot of a
more loaded ultrabook.

I will try to reproduce the configuration on your omap and fix seg
fault. thanks for the data.

> >>> --- /dev/null
> >>> +++ b/tools/thermal/tmon/sysfs.c
> >>> @@ -0,0 +1,585 @@
> >>> +/*
> >>> + * sysfs.c sysfs ABI access functions for TMON program
> >>> + *
> >>> + * Copyright (C) 2013 Intel Corporation. All rights reserved.
> >>> + *
> >>> + * This program is free software; you can redistribute it and/or
> >>> + * modify it under the terms of the GNU General Public License
> >>> version
> >>> + * 2 or later as published by the Free Software Foundation.
> >>> + *
> >>> + * This program is distributed in the hope that it will be
> >>> useful,
> >>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>> + * GNU General Public License for more details.
> >>> + *
> >>> + * Author: Jacob Pan <jacob.jun.pan@linux.intel.com>
> >>> + *
> >>> + */
> >>> +#include <unistd.h>
> >>> +#include <stdio.h>
> >>> +#include <stdlib.h>
> >>> +#include <string.h>
> >>> +#include <stdint.h>
> >>> +#include <dirent.h>
> >>> +#include <libintl.h>
> >>> +#include <ctype.h>
> >>> +#include <time.h>
> >>> +#include <syslog.h>
> >>> +#include <sys/time.h>
> >>> +#include <errno.h>
> >>> +
> >>> +#include "tmon.h"
> >>> +
> >>> +struct tmon_platform_data ptdata;
> >>> +const char *trip_type_name[] =3D {
> >>> +	"critical",
> >>> +	"hot",
> >>> +	"passive",
> >>> +	"active",
> >>> +};
> >>> +
> >>> +int sysfs_set_ulong(char *path, char *filename, unsigned long
> >>> val) +{
> >>> +	FILE *fd;
> >>> +	int ret =3D -1;
> >>> +	char filepath[256];
> >>> +
> >>> +	snprintf(filepath, 256, "%s/%s", path, filename);
> >>> +
> >>> +	fd =3D fopen(filepath, "w");
> >>> +	if (!fd) {
> >>> +		syslog(LOG_ERR, "Err: open %s: %s\n", __func__,
> >>> filepath);
> >>> +		return ret;
> >>> +	}
> >>> +	ret =3D fprintf(fd, "%lu", val);
> >>> +	fclose(fd);
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +/* history of thermal data, used for control algo */
> >>> +#define NR_THERMAL_RECORDS 3
> >>> +struct thermal_data_record trec[NR_THERMAL_RECORDS];
> >>> +int cur_thermal_record; /* index to the trec array */
> >>> +
> >>> +static int sysfs_get_ulong(char *path, char *filename, unsigned
> >>> long *p_ulong) +{
> >>> +	FILE *fd;
> >>> +	int ret =3D -1;
> >>> +	char filepath[256];
> >>> +
> >>> +	snprintf(filepath, 256, "%s/%s", path, filename);
> >>> +
> >>> +	fd =3D fopen(filepath, "r");
> >>> +	if (!fd) {
> >>> +		syslog(LOG_ERR, "Err: open %s: %s\n", __func__,
> >>> filepath);
> >>> +		return ret;
> >>> +	}
> >>> +	ret =3D fscanf(fd, "%lu", p_ulong);
> >>> +	fclose(fd);
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static int sysfs_get_string(char *path, char *filename, char
> >>> *str) +{
> >>> +	FILE *fd;
> >>> +	int ret =3D -1;
> >>> +	char filepath[256];
> >>> +
> >>> +	snprintf(filepath, 256, "%s/%s", path, filename);
> >>> +
> >>> +	fd =3D fopen(filepath, "r");
> >>> +	if (!fd) {
> >>> +		syslog(LOG_ERR, "Err: open %s: %s\n", __func__,
> >>> filepath);
> >>> +		return ret;
> >>> +	}
> >>> +	ret =3D fscanf(fd, "%256s", str);
> >>> +	fclose(fd);
> >>> +
> >>> +	return ret;
> >>> +}
> >>> +
> >>> +/* get states of the cooling device instance */
> >>> +static int probe_cdev(struct cdev_info *cdi, char *path)
> >>> +{
> >>> +	sysfs_get_string(path, "type", cdi->type);
> >>> +	sysfs_get_ulong(path, "max_state",  &cdi->max_state);
> >>> +	sysfs_get_ulong(path, "cur_state", &cdi->cur_state);
> >>> +
> >>> +	syslog(LOG_INFO, "%s: %s: type %s, max %lu, curr %lu inst
> >>> %d\n",
> >>> +		__func__, path,
> >>> +		cdi->type, cdi->max_state, cdi->cur_state,
> >>> cdi->instance); +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static int str_to_trip_type(char *name)
> >>> +{
> >>> +	int i;
> >>> +
> >>> +	for (i =3D 0; i < NR_THERMAL_TRIP_TYPE; i++) {
> >>> +		if (!strcmp(name, trip_type_name[i]))
> >>> +			return i;
> >>> +	}
> >>> +
> >>> +	return -ENOENT;
> >>> +}
> >>> +
> >>> +/* scan and fill in trip point info for a thermal zone and trip
> >>> point id */ +static int get_trip_point_data(char *tz_path, int
> >>> tzid, int tpid) +{
> >>> +	char filename[256];
> >>> +	char temp_str[256];
> >>> +	int trip_type;
> >>> +
> >>> +	if (tpid >=3D MAX_NR_TRIP)
> >>> +		return -EINVAL;
> >>> +	/* check trip point type */
> >>> +	snprintf(filename, sizeof(filename),
> >>> "trip_point_%d_type", tpid);
> >>> +	sysfs_get_string(tz_path, filename, temp_str);
> >>> +	trip_type =3D str_to_trip_type(temp_str);
> >>> +	if (trip_type < 0) {
> >>> +		syslog(LOG_ERR, "%s:%s no matching type\n",
> >>> __func__, temp_str);
> >>> +		return -ENOENT;
> >>> +	}
> >>> +	ptdata.tzi[tzid].tp[tpid].type =3D trip_type;
> >>> +	syslog(LOG_INFO, "%s:tz:%d tp:%d:type:%s type id %d\n",
> >>> __func__, tzid,
> >>> +		tpid, temp_str, trip_type);
> >>> +
> >>> +	/* TODO: check attribute */
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +/* return instance id for file format such as trip_point_4_temp
> >>> */ +static int get_instance_id(char *name, int pos, int skip)
> >>> +{
> >>> +	char *ch;
> >>> +	int i =3D 0;
> >>> +
> >>> +	ch =3D strtok(name, "_");
> >>> +	while (ch !=3D NULL) {
> >>> +		++i;
> >>> +		syslog(LOG_INFO, "%s:%s:%s:%d", __func__, name,
> >>> ch, i);
> >>> +		ch =3D strtok(NULL, "_");
> >>> +		if (pos =3D=3D i)
> >>> +			return atol(ch + skip);
> >>> +	}
> >>> +
> >>> +	return -1;
> >>> +}
> >>> +
> >>> +/* Find trip point info of a thermal zone */
> >>> +static int find_tzone_tp(char *tz_name, char *d_name, struct
> >>> tz_info *tzi,
> >>> +			int tz_id)
> >>> +{
> >>> +	int tp_id;
> >>> +	unsigned long temp_ulong;
> >>> +
> >>> +	if (strstr(d_name, "trip_point") &&
> >>> +		strstr(d_name, "temp")) {
> >>> +		/* check if trip point temp is non-zero
> >>> +		 * ignore 0/invalid trip points
> >>> +		 */
> >>> +		sysfs_get_ulong(tz_name, d_name, &temp_ulong);
> >>> +		if (temp_ulong < MAX_TEMP_KC) {
> >>> +			tzi->nr_trip_pts++;
> >>> +			/* found a valid trip point */
> >>> +			tp_id =3D get_instance_id(d_name, 2, 0);
> >>> +			syslog(LOG_DEBUG, "tzone %s trip %d temp
> >>> %lu tpnode %s",
> >>> +				tz_name, tp_id, temp_ulong,
> >>> d_name);
> >>> +			if (tp_id < 0 || tp_id >=3D MAX_NR_TRIP) {
> >>> +				syslog(LOG_ERR, "Failed to find
> >>> TP inst %s\n",
> >>> +					d_name);
> >>> +				return -1;
> >>> +			}
> >>> +			get_trip_point_data(tz_name, tz_id,
> >>> tp_id);
> >>> +			tzi->tp[tp_id].temp =3D temp_ulong;
> >>> +		}
> >>> +	}
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +/* check cooling devices for binding info. */
> >>> +static int find_tzone_cdev(struct dirent *nl, char *tz_name,
> >>> +			struct tz_info *tzi, int tz_id, int cid)
> >>> +{
> >>> +	unsigned long trip_instance =3D 0;
> >>> +	char cdev_name_linked[256];
> >>> +	char cdev_name[256];
> >>> +	char cdev_trip_name[256];
> >>> +	int cdev_id;
> >>> +
> >>> +	if (nl->d_type =3D=3D DT_LNK) {
> >>> +		syslog(LOG_DEBUG, "TZ%d: cdev: %s cid %d\n",
> >>> tz_id, nl->d_name,
> >>> +			cid);
> >>> +		tzi->nr_cdev++;
> >>> +		if (tzi->nr_cdev > ptdata.nr_cooling_dev) {
> >>> +			syslog(LOG_ERR, "Err: Too many cdev?
> >>> %d\n",
> >>> +				tzi->nr_cdev);
> >>> +			return -EINVAL;
> >>> +		}
> >>> +		/* find the link to real cooling device record
> >>> binding */
> >>> +		snprintf(cdev_name, 256, "%s/%s", tz_name,
> >>> nl->d_name);
> >>> +		memset(cdev_name_linked, 0,
> >>> sizeof(cdev_name_linked));
> >>> +		if (readlink(cdev_name, cdev_name_linked,
> >>> +				sizeof(cdev_name_linked) - 1) !=3D
> >>> -1) {
> >>> +			cdev_id =3D
> >>> get_instance_id(cdev_name_linked, 1,
> >>> +						sizeof("device")
> >>> - 1);
> >>> +			syslog(LOG_DEBUG, "cdev %s linked to %s :
> >>> %d\n",
> >>> +				cdev_name, cdev_name_linked,
> >>> cdev_id);
> >>> +			tzi->cdev_binding |=3D (1 << cdev_id);
> >>> +
> >>> +			/* find the trip point in which the cdev
> >>> is binded to
> >>> +			 * in this tzone
> >>> +			 */
> >>> +			snprintf(cdev_trip_name, 256, "%s%s",
> >>> nl->d_name,
> >>> +				"_trip_point");
> >>> +			sysfs_get_ulong(tz_name, cdev_trip_name,
> >>> +					&trip_instance);
> >>> +			/* validate trip point range, e.g. trip
> >>> could return -1
> >>> +			 * when passive is enabled
> >>> +			 */
> >>> +			if (trip_instance > MAX_NR_TRIP)
> >>> +				trip_instance =3D 0;
> >>> +			tzi->trip_binding[cdev_id] |=3D 1 <<
> >>> trip_instance;
> >>> +			syslog(LOG_DEBUG, "cdev %s -> trip:%lu:
> >>> 0x%lx %d\n",
> >>> +				cdev_name, trip_instance,
> >>> +				tzi->trip_binding[cdev_id],
> >>> +				cdev_id);
> >>> +
> >>> +
> >>> +		}
> >>> +		return 0;
> >>> +	}
> >>> +
> >>> +	return -ENODEV;
> >>> +}
> >>> +
> >>> +
> >>> +
> >>> +/*******************************************************************=
**********
> >>> + * Before calling scan_tzones, thermal sysfs must be probed to
> >>> determine
> >>> + * the number of thermal zones and cooling devices.
> >>> + * We loop through each thermal zone and fill in tz_info struct,
> >>> i.e.
> >>> + * ptdata.tzi[]
> >>> +root@jacob-chiefriver:~# tree -d /sys/class/thermal/thermal_zone0
> >>> +/sys/class/thermal/thermal_zone0
> >>> +|-- cdev0 -> ../cooling_device4
> >>> +|-- cdev1 -> ../cooling_device3
> >>> +|-- cdev10 -> ../cooling_device7
> >>> +|-- cdev11 -> ../cooling_device6
> >>> +|-- cdev12 -> ../cooling_device5
> >>> +|-- cdev2 -> ../cooling_device2
> >>> +|-- cdev3 -> ../cooling_device1
> >>> +|-- cdev4 -> ../cooling_device0
> >>> +|-- cdev5 -> ../cooling_device12
> >>> +|-- cdev6 -> ../cooling_device11
> >>> +|-- cdev7 -> ../cooling_device10
> >>> +|-- cdev8 -> ../cooling_device9
> >>> +|-- cdev9 -> ../cooling_device8
> >>> +|-- device -> ../../../LNXSYSTM:00/device:62/LNXTHERM:00
> >>> +|-- power
> >>> +`-- subsystem -> ../../../../class/thermal
> >>> +********************************************************************=
*********/
> >>> +static int scan_tzones(void)
> >>> +{
> >>> +	DIR *dir;
> >>> +	struct dirent **namelist;
> >>> +	char tz_name[256];
> >>> +	int i, j, n, k =3D 0;
> >>> +
> >>> +	if (!ptdata.nr_tz_sensor) {
> >>> +		syslog(LOG_ERR, "No thermal zones found!\n");
> >>> +		return -1;
> >>> +	}
> >>> +
> >>> +	for (i =3D 0; i <=3D ptdata.max_tz_instance; i++) {
> >>> +		memset(tz_name, 0, sizeof(tz_name));
> >>> +		snprintf(tz_name, 256, "%s/%s%d", THERMAL_SYSFS,
> >>> TZONE, i); +
> >>> +		dir =3D opendir(tz_name);
> >>> +		if (!dir) {
> >>> +			syslog(LOG_INFO, "Thermal zone %s
> >>> skipped\n", tz_name);
> >>> +			continue;
> >>> +		}
> >>> +		/* keep track of valid tzones */
> >>> +		n =3D scandir(tz_name, &namelist, 0, alphasort);
> >>> +		if (n < 0)
> >>> +			syslog(LOG_ERR, "scandir failed in %s",
> >>> tz_name);
> >>> +		else {
> >>> +			sysfs_get_string(tz_name, "type",
> >>> ptdata.tzi[k].type);
> >>> +			ptdata.tzi[k].instance =3D i;
> >>> +			/* detect trip points and cdev attached
> >>> to this tzone */
> >>> +			j =3D 0; /* index for cdev */
> >>> +			ptdata.tzi[k].nr_cdev =3D 0;
> >>> +			ptdata.tzi[k].nr_trip_pts =3D 0;
> >>> +			while (n--) {
> >>> +				char *temp_str;
> >>> +
> >>> +				if (find_tzone_tp(tz_name,
> >>> namelist[n]->d_name,
> >>> +
> >>> &ptdata.tzi[k], k))
> >>> +					break;
> >>> +				temp_str =3D
> >>> strstr(namelist[n]->d_name, "cdev");
> >>> +				if (!temp_str) {
> >>> +					free(namelist[n]);
> >>> +					continue;
> >>> +				}
> >>> +				if (!find_tzone_cdev(namelist[n],
> >>> tz_name,
> >>> +
> >>> &ptdata.tzi[k], i, j))
> >>> +					j++; /* increment cdev
> >>> index */
> >>> +				free(namelist[n]);
> >>> +			}
> >>> +			free(namelist);
> >>> +		}
> >>> +		/*TODO: reverse trip points */
> >>> +		closedir(dir);
> >>> +		syslog(LOG_INFO, "TZ %d has %d cdev\n",	i,
> >>> +			ptdata.tzi[k].nr_cdev);
> >>> +		k++;
> >>> +	}
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static int scan_cdevs(void)
> >>> +{
> >>> +	DIR *dir;
> >>> +	struct dirent **namelist;
> >>> +	char cdev_name[256];
> >>> +	int i, n, k =3D 0;
> >>> +
> >>> +	for (i =3D 0; i <=3D ptdata.max_cdev_instance; i++) {
> >>> +		memset(cdev_name, 0, sizeof(cdev_name));
> >>> +		snprintf(cdev_name, 256, "%s/%s%d",
> >>> THERMAL_SYSFS, CDEV, i); +
> >>> +		dir =3D opendir(cdev_name);
> >>> +		if (!dir) {
> >>> +			syslog(LOG_INFO, "Cooling dev %s
> >>> skipped\n", cdev_name);
> >>> +			/* there is a gap in cooling device id,
> >>> check again
> >>> +			 * for the same index.
> >>> +			 */
> >>> +			continue;
> >>> +		}
> >>> +
> >>> +		n =3D scandir(cdev_name, &namelist, 0, alphasort);
> >>> +		if (n < 0)
> >>> +			syslog(LOG_ERR, "scandir failed in %s",
> >>> cdev_name);
> >>> +		else {
> >>> +			sysfs_get_string(cdev_name, "type",
> >>> ptdata.cdi[k].type);
> >>> +			ptdata.cdi[k].instance =3D i;
> >>> +			if (strstr(ptdata.cdi[k].type,
> >>> ctrl_cdev)) {
> >>> +				ptdata.cdi[k].flag |=3D
> >>> CDEV_FLAG_IN_CONTROL;
> >>> +				syslog(LOG_DEBUG, "control cdev
> >>> id %d\n", i);
> >>> +			}
> >>> +			while (n--)
> >>> +				free(namelist[n]);
> >>> +			free(namelist);
> >>> +		}
> >>> +		closedir(dir);
> >>> +		k++;
> >>> +	}
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +
> >>> +int probe_thermal_sysfs(void)
> >>> +{
> >>> +	DIR *dir;
> >>> +	struct dirent **namelist;
> >>> +	int n;
> >>> +
> >>> +	dir =3D opendir(THERMAL_SYSFS);
> >>> +	if (!dir) {
> >>> +		syslog(LOG_ERR, "No thermal sysfs\n");
> >>> +		return -1;
> >>> +	}
> >>> +	n =3D scandir(THERMAL_SYSFS, &namelist, 0, alphasort);
> >>> +	if (n < 0)
> >>> +		syslog(LOG_ERR, "scandir failed in thermal
> >>> sysfs");
> >>> +	else {
> >>> +		/* detect number of thermal zones and cooling
> >>> devices */
> >>> +		while (n--) {
> >>> +			int inst;
> >>> +
> >>> +			if (strstr(namelist[n]->d_name, CDEV)) {
> >>> +				inst =3D
> >>> get_instance_id(namelist[n]->d_name, 1,
> >>> +						sizeof("device")
> >>> - 1);
> >>> +				/* keep track of the max cooling
> >>> device since
> >>> +				 * there may be gaps.
> >>> +				 */
> >>> +				if (inst >
> >>> ptdata.max_cdev_instance)
> >>> +					ptdata.max_cdev_instance
> >>> =3D inst; +
> >>> +				syslog(LOG_DEBUG, "found cdev: %s
> >>> %d %d\n",
> >>> +					namelist[n]->d_name,
> >>> +					ptdata.nr_cooling_dev,
> >>> +
> >>> ptdata.max_cdev_instance);
> >>> +				ptdata.nr_cooling_dev++;
> >>> +			} else if (strstr(namelist[n]->d_name,
> >>> TZONE)) {
> >>> +				inst =3D
> >>> get_instance_id(namelist[n]->d_name, 1,
> >>> +						sizeof("zone") -
> >>> 1);
> >>> +				if (inst >
> >>> ptdata.max_tz_instance)
> >>> +					ptdata.max_tz_instance =3D
> >>> inst; +
> >>> +				syslog(LOG_DEBUG, "found tzone:
> >>> %s %d %d\n",
> >>> +					namelist[n]->d_name,
> >>> +					ptdata.nr_tz_sensor,
> >>> +					ptdata.max_tz_instance);
> >>> +				ptdata.nr_tz_sensor++;
> >>> +			}
> >>> +			free(namelist[n]);
> >>> +		}
> >>> +		free(namelist);
> >>> +	}
> >>> +	syslog(LOG_INFO, "found %d tzone(s), %d cdev(s), target
> >>> zone %d\n",
> >>> +		ptdata.nr_tz_sensor, ptdata.nr_cooling_dev,
> >>> +		target_thermal_zone);
> >>> +	closedir(dir);
> >>> +
> >>> +	ptdata.tzi =3D calloc(sizeof(struct tz_info),
> >>> ptdata.nr_tz_sensor+1);
> >>> +	if (!ptdata.tzi) {
> >>> +		syslog(LOG_ERR, "Err: allocate tz_info\n");
> >>> +		return -1;
> >>> +	}
> >>> +
> >>> +	ptdata.cdi =3D calloc(sizeof(struct cdev_info),
> >>> ptdata.nr_cooling_dev+1);
> >>> +	if (!ptdata.cdi) {
> >>> +		syslog(LOG_ERR, "Err: allocate cdev_info\n");
> >>> +		return -1;
> >>> +	}
> >>> +
> >>> +	/* now probe tzones */
> >>> +	if (scan_tzones())
> >>> +		return -1;
> >>> +	if (scan_cdevs())
> >>> +		return -1;
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +/* convert sysfs zone instance to zone array index */
> >>> +int zone_instance_to_index(int zone_inst)
> >>> +{
> >>> +	int i;
> >>> +
> >>> +	for (i =3D 0; i < ptdata.nr_tz_sensor; i++)
> >>> +		if (ptdata.tzi[i].instance =3D=3D zone_inst)
> >>> +			return i;
> >>> +	return -ENOENT;
> >>> +}
> >>> +
> >>> +/* read temperature of all thermal zones */
> >>> +int update_thermal_data()
> >>> +{
> >>> +	int i;
> >>> +	char tz_name[256];
> >>> +	static unsigned long samples;
> >>> +
> >>> +	if (!ptdata.nr_tz_sensor) {
> >>> +		syslog(LOG_ERR, "No thermal zones found!\n");
> >>> +		return -1;
> >>> +	}
> >>> +
> >>> +	/* circular buffer for keeping historic data */
> >>> +	if (cur_thermal_record >=3D NR_THERMAL_RECORDS)
> >>> +		cur_thermal_record =3D 0;
> >>> +	gettimeofday(&trec[cur_thermal_record].tv, NULL);
> >>> +	if (tmon_log) {
> >>> +		fprintf(tmon_log, "%lu ", ++samples);
> >>> +		fprintf(tmon_log, "%3.1f ", p_param.t_target);
> >>> +	}
> >>> +	for (i =3D 0; i < ptdata.nr_tz_sensor; i++) {
> >>> +		memset(tz_name, 0, sizeof(tz_name));
> >>> +		snprintf(tz_name, 256, "%s/%s%d", THERMAL_SYSFS,
> >>> TZONE,
> >>> +			ptdata.tzi[i].instance);
> >>> +		sysfs_get_ulong(tz_name, "temp",
> >>> +
> >>> &trec[cur_thermal_record].temp[i]);
> >>> +		if (tmon_log)
> >>> +			fprintf(tmon_log, "%lu ",
> >>> +
> >>> trec[cur_thermal_record].temp[i]/1000);
> >>> +	}
> >>> +	for (i =3D 0; i < ptdata.nr_cooling_dev; i++) {
> >>> +		char cdev_name[256];
> >>> +		unsigned long val;
> >>> +
> >>> +		snprintf(cdev_name, 256, "%s/%s%d",
> >>> THERMAL_SYSFS, CDEV,
> >>> +			ptdata.cdi[i].instance);
> >>> +		probe_cdev(&ptdata.cdi[i], cdev_name);
> >>> +		val =3D ptdata.cdi[i].cur_state;
> >>> +		if (val > 1000000)
> >>> +			val =3D 0;
> >>> +		if (tmon_log)
> >>> +			fprintf(tmon_log, "%lu ", val);
> >>> +	}
> >>> +
> >>> +	if (tmon_log) {
> >>> +		fprintf(tmon_log, "\n");
> >>> +		fflush(tmon_log);
> >>> +	}
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +void set_ctrl_state(unsigned long state)
> >>> +{
> >>> +	char ctrl_cdev_path[256];
> >>> +	int i;
> >>> +	unsigned long cdev_state;
> >>> +
> >>> +	if (no_control)
> >>> +		return;
> >>> +	/* set all ctrl cdev to the same state */
> >>> +	for (i =3D 0; i < ptdata.nr_cooling_dev; i++) {
> >>> +		if (ptdata.cdi[i].flag & CDEV_FLAG_IN_CONTROL) {
> >>> +			if (ptdata.cdi[i].max_state < 10) {
> >>> +				syslog(LOG_WARNING,
> >>> +					"not enough states in
> >>> control cdev\n");
> >>> +				return;
> >>> +			}
> >>> +			/* scale to percentage of max_state */
> >>> +			cdev_state =3D state *
> >>> ptdata.cdi[i].max_state/100;
> >>> +			syslog(LOG_DEBUG,
> >>> +				"ctrl cdev %d set state %lu
> >>> scaled to %lu\n",
> >>> +				ptdata.cdi[i].instance, state,
> >>> cdev_state);
> >>> +			snprintf(ctrl_cdev_path, 256, "%s/%s%d",
> >>> THERMAL_SYSFS,
> >>> +				CDEV, ptdata.cdi[i].instance);
> >>> +			syslog(LOG_DEBUG, "ctrl cdev path %s",
> >>> ctrl_cdev_path);
> >>> +			sysfs_set_ulong(ctrl_cdev_path,
> >>> "cur_state",
> >>> +					cdev_state);
> >>> +		}
> >>> +	}
> >>> +}
> >>> +
> >>> +void get_ctrl_state(unsigned long *state)
> >>> +{
> >>> +	char ctrl_cdev_path[256];
> >>> +	int ctrl_cdev_id =3D -1;
> >>> +	int i;
> >>> +
> >>> +	/* TODO: take average of all ctrl types. also consider
> >>> change based on
> >>> +	 * uevent. Take the first reading for now.
> >>> +	 */
> >>> +	for (i =3D 0; i < ptdata.nr_cooling_dev; i++) {
> >>> +		if (ptdata.cdi[i].flag & CDEV_FLAG_IN_CONTROL) {
> >>> +			ctrl_cdev_id =3D ptdata.cdi[i].instance;
> >>> +			syslog(LOG_INFO, "ctrl cdev %d get
> >>> state\n",
> >>> +				ptdata.cdi[i].instance);
> >>> +			break;
> >>> +		}
> >>> +	}
> >>> +	if (ctrl_cdev_id =3D=3D -1) {
> >>> +		*state =3D 0;
> >>> +		return;
> >>> +	}
> >>> +	snprintf(ctrl_cdev_path, 256, "%s/%s%d", THERMAL_SYSFS,
> >>> +		CDEV, ctrl_cdev_id);
> >>> +	sysfs_get_ulong(ctrl_cdev_path, "cur_state", state);
> >>> +}
> >>> +
> >>> +void free_thermal_data(void)
> >>> +{
> >>> +	free(ptdata.tzi);
> >>> +	free(ptdata.cdi);
> >>> +}
> >>> diff --git a/tools/thermal/tmon/tmon.8 b/tools/thermal/tmon/tmon.8
> >>> new file mode 100644
> >>> index 0000000..0be727c
> >>> --- /dev/null
> >>> +++ b/tools/thermal/tmon/tmon.8
> >>> @@ -0,0 +1,142 @@
> >>> +.TH TMON 8
> >>> +.SH NAME
> >>> +\fBtmon\fP - A monitoring and testing tool for Linux kernel
> >>> thermal subsystem +
> >>> +.SH SYNOPSIS
> >>> +.ft B
> >>> +.B tmon
> >>> +.RB [ Options ]
> >>> +.br
> >>> +.SH DESCRIPTION
> >>> +\fBtmon \fP can be used to visualize thermal relationship and
> >>> +real-time thermal data; tune
> >>> +and test cooling devices and sensors; collect thermal data for
> >>> offline +analysis and plot. \fBtmon\fP must be run as root in
> >>> order to control device +states via sysfs.
> >>> +.PP
> >>> +\fBFunctions\fP
> >>> +.PP
> >>> +.nf
> >>> +1. Thermal relationships:
> >>> +- show thermal zone information
> >>> +- show cooling device information
> >>> +- show trip point binding within each thermal zone
> >>> +- show trip point and cooling device instance bindings
> >>> +.PP
> >>> +2. Real time data display
> >>> +- show temperature of all thermal zones w.r.t. its trip points
> >>> and types +- show states of all cooling devices
> >>> +.PP
> >>> +3. Thermal relationship learning and device tuning
> >>> +- with a built-in Proportional Integral Derivative (\fBPID\fP)
> >>> +controller, user can pair a cooling device to a thermal sensor
> >>> for +testing the effectiveness and learn about the thermal
> >>> distance between the two +- allow manual control of cooling
> >>> device states and target temperature +.PP
> >>> +4. Data logging in /var/tmp/tmon.log
> >>> +- contains thermal configuration data, i.e. cooling device,
> >>> thermal
> >>> + zones, and trip points. Can be used for data  collection in
> >>> remote
> >>> + debugging.
> >>> +- log real-time thermal data into space separated format that can
> >>> be
> >>> + directly consumed by plotting tools such as Rscript.
> >>> +
> >>> +.SS Options
> >>> +.PP
> >>> +The \fB-c --control\fP option sets a cooling device type to
> >>> control temperature +of a thermal zone
> >>> +.PP
> >>> +The \fB-d --daemon\fP option runs \fBtmon \fP as daemon without
> >>> user interface +.PP
> >>> +The \fB-g --debug\fP option allow debug messages to be stored in
> >>> syslog +.PP
> >>> +The \fB-h --help\fP option shows help message
> >>> +.PP
> >>> +The \fB-l --log\fP option write data to /var/tmp/tmon.log
> >>> +.PP
> >>> +The \fB-t --time-interval\fP option sets the polling interval in
> >>> seconds +.PP
> >>> +The \fB-v --version\fP option shows the version of \fBtmon \fP
> >>> +.PP
> >>> +The \fB-z --zone\fP option sets the target therma zone instance
> >>> to be controlled +.PP
> >>> +
> >>> +.SH FIELD DESCRIPTIONS
> >>> +.nf
> >>> +.PP
> >>> +\fBP \fP passive cooling trip point type
> >>> +\fBA \fP active cooling trip point type (fan)
> >>> +\fBC \fP critical trip point type
> >>> +\fBA \fP hot trip point type
> >>> +\fBkp \fP proportional gain of \fBPID\fP controller
> >>> +\fBki \fP integral gain of \fBPID\fP controller
> >>> +\fBkd \fP derivative gain of \fBPID\fP controller
> >>> +
> >>> +.SH REQUIREMENT
> >>> +Build depends on ncurses
> >>> +.PP
> >>> +Runtime depends on window size large enough to show the number of
> >>> +devices found on the system.
> >>> +
> >>> +.PP
> >>> +
> >>> +.SH INTERACTIVE COMMANDS
> >>> +.pp
> >>> +.nf
> >>> +\fBCtrl-C, q/Q\fP stops \fBtmon\fP
> >>> +\fBTAB\fP shows tuning pop up panel, choose a letter to modify
> >>> +
> >>> +.SH EXAMPLES
> >>> +Without any parameters, tmon is in monitoring only mode and
> >>> refresh +screen every 1 second.
> >>> +.PP
> >>> +1. For monitoring only:
> >>> +.nf
> >>> +$ sudo ./tmon
> >>> +
> >>> +2. Use Processor cooling device to control thermal zone 0 at
> >>> default 65C. +$ sudo ./tmon -c Processor -z 0
> >>> +
> >>> +3. Use intel_powerclamp(idle injection) cooling device to control
> >>> thermal zone 1 +$ sudo ./tmon -c intel_powerclamp -z 1
> >>> +
> >>> +4. Turn on debug and collect data log at /var/tmp/tmon.log
> >>> +$ sudo ./tmon -g -l
> >>> +
> >>> +For example, the log below shows PID controller was adjusting
> >>> current states +for all cooling devices with "Processor" type such
> >>> that thermal zone 0 +can stay below 65 dC.
> >>> +
> >>> +#---------- THERMAL DATA LOG STARTED -----------
> >>> +Samples TargetTemp acpitz0    acpitz1    Fan0 Fan1 Fan2 Fan3 Fan4
> >>> Fan5 +Fan6 Fan7 Fan8 Fan9 Processor10 Processor11 Processor12
> >>> Processor13 +LCD14 intel_powerclamp15 1 65.0 65 65 0 0 0 0 0 0 0 0
> >>> 0 0 0 0 0 0 6 0 2 +65.0 66 65 0 0 0 0 0 0 0 0 0 0 4 4 4 4 6 0 3
> >>> 65.0 60 54 0 0 0 0 0 0 0 0 +0 0 4 4 4 4 6 0 4 65.0 53 53 0 0 0 0 0
> >>> 0 0 0 0 0 4 4 4 4 6 0 +5 65.0 52 52 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6
> >>> 0 +6 65.0 53 65 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 0
> >>> +7 65.0 68 70 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 0
> >>> +8 65.0 68 68 0 0 0 0 0 0 0 0 0 0 5 5 5 5 6 0
> >>> +9 65.0 68 68 0 0 0 0 0 0 0 0 0 0 6 6 6 6 6 0
> >>> +10 65.0 67 67 0 0 0 0 0 0 0 0 0 0 7 7 7 7 6 0
> >>> +11 65.0 67 67 0 0 0 0 0 0 0 0 0 0 8 8 8 8 6 0
> >>> +12 65.0 67 67 0 0 0 0 0 0 0 0 0 0 8 8 8 8 6 0
> >>> +13 65.0 67 67 0 0 0 0 0 0 0 0 0 0 9 9 9 9 6 0
> >>> +14 65.0 66 66 0 0 0 0 0 0 0 0 0 0 10 10 10 10 6 0
> >>> +15 65.0 66 67 0 0 0 0 0 0 0 0 0 0 10 10 10 10 6 0
> >>> +16 65.0 66 66 0 0 0 0 0 0 0 0 0 0 11 11 11 11 6 0
> >>> +17 65.0 66 66 0 0 0 0 0 0 0 0 0 0 11 11 11 11 6 0
> >>> +18 65.0 64 61 0 0 0 0 0 0 0 0 0 0 11 11 11 11 6 0
> >>> +19 65.0 60 59 0 0 0 0 0 0 0 0 0 0 12 12 12 12 6 0
> >>> +
> >>> +Data can be read directly into an array by an example R-script
> >>> below: +
> >>> +#!/usr/bin/Rscript
> >>> +tdata <- read.table("/var/tmp/tmon.log", header=3DT,
> >>> comment.char=3D"#") +attach(tdata)
> >>> +jpeg("tmon.jpg")
> >>> +X11()
> >>> +g_range <- range(0, intel_powerclamp15, TargetTemp, acpitz0)
> >>> +plot( Samples, intel_powerclamp15, col=3D"blue", ylim=3Dg_range,
> >>> axes=3DFALSE, ann=3DFALSE) +par(new=3DTRUE)
> >>> +lines(TargetTemp, type=3D"o", pch=3D22, lty=3D2, col=3D"red")
> >>> +dev.off()
> >>> diff --git a/tools/thermal/tmon/tmon.c b/tools/thermal/tmon/tmon.c
> >>> new file mode 100644
> >>> index 0000000..5f13fb1
> >>> --- /dev/null
> >>> +++ b/tools/thermal/tmon/tmon.c
> >>> @@ -0,0 +1,350 @@
> >>> +/*
> >>> + * tmon.c Thermal Monitor (TMON) main function and entry point
> >>> + *
> >>> + * Copyright (C) 2012 Intel Corporation. All rights reserved.
> >>> + *
> >>> + * This program is free software; you can redistribute it and/or
> >>> + * modify it under the terms of the GNU General Public License
> >>> version
> >>> + * 2 or later as published by the Free Software Foundation.
> >>> + *
> >>> + * This program is distributed in the hope that it will be
> >>> useful,
> >>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>> + * GNU General Public License for more details.
> >>> + *
> >>> + * Author: Jacob Pan <jacob.jun.pan@linux.intel.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#include <getopt.h>
> >>> +#include <unistd.h>
> >>> +#include <stdio.h>
> >>> +#include <stdlib.h>
> >>> +#include <string.h>
> >>> +#include <sys/types.h>
> >>> +#include <sys/stat.h>
> >>> +#include <ncurses.h>
> >>> +#include <ctype.h>
> >>> +#include <time.h>
> >>> +#include <signal.h>
> >>> +#include <limits.h>
> >>> +#include <sys/time.h>
> >>> +#include <pthread.h>
> >>> +#include <math.h>
> >>> +#include <stdarg.h>
> >>> +#include <syslog.h>
> >>> +
> >>> +#include "tmon.h"
> >>> +
> >>> +unsigned long ticktime =3D 1; /* seconds */
> >>> +unsigned long no_control =3D 1; /* monitoring only or use cooling
> >>> device for
> >>> +			       * temperature control.
> >>> +			       */
> >>> +double time_elapsed =3D 0.0;
> >>> +unsigned long target_temp_user =3D 65; /* can be select by tui
> >>> later */ +int dialogue_on;
> >>> +int tmon_exit;
> >>> +static short	daemon_mode;
> >>> +static int logging; /* for recording thermal data to a file */
> >>> +static int debug_on;
> >>> +FILE *tmon_log;
> >>> +char ctrl_cdev[CDEV_NAME_SIZE]; /*cooling device used for the PID
> >>> controller */ +int target_thermal_zone; /* user selected target
> >>> zone instance */ +static void	start_daemon_mode(void);
> >>> +
> >>> +pthread_t event_tid;
> >>> +pthread_mutex_t input_lock;
> >>> +void usage()
> >>> +{
> >>> +	printf("Usage: tmon [OPTION...]\n");
> >>> +	printf("  -c, --control         cooling device in
> >>> control\n");
> >>> +	printf("  -d, --daemon          run as daemon, no
> >>> TUI\n");
> >>> +	printf("  -g, --debug           debug message in
> >>> syslog\n");
> >>> +	printf("  -h, --help            show this help
> >>> message\n");
> >>> +	printf("  -l, --log             log data
> >>> to /var/tmp/tmon.log\n");
> >>> +	printf("  -t, --time-interval   sampling time interval, >
> >>> 1 sec.\n");
> >>> +	printf("  -v, --version         show version\n");
> >>> +	printf("  -z, --zone            target thermal zone
> >>> id\n"); +
> >>> +	exit(0);
> >>> +}
> >>> +
> >>> +void version()
> >>> +{
> >>> +	printf("TMON version %s\n", VERSION);
> >>> +	exit(EXIT_SUCCESS);
> >>> +}
> >>> +
> >>> +static void tmon_cleanup(void)
> >>> +{
> >>> +
> >>> +	syslog(LOG_INFO, "TMON exit cleanup\n");
> >>> +	fflush(stdout);
> >>> +	refresh();
> >>> +	if (tmon_log)
> >>> +		fclose(tmon_log);
> >>> +	if (event_tid) {
> >>> +		pthread_mutex_lock(&input_lock);
> >>> +		pthread_cancel(event_tid);
> >>> +		pthread_mutex_unlock(&input_lock);
> >>> +		pthread_mutex_destroy(&input_lock);
> >>> +	}
> >>> +	closelog();
> >>> +	/* relax control knobs, undo throttling */
> >>> +	set_ctrl_state(0);
> >>> +
> >>> +	keypad(stdscr, FALSE);
> >>> +	echo();
> >>> +	nocbreak();
> >>> +	close_windows();
> >>> +	endwin();
> >>> +	free_thermal_data();
> >>> +
> >>> +	exit(1);
> >>> +}
> >>> +
> >>> +
> >>> +static void tmon_sig_handler(int sig)
> >>> +{
> >>> +	syslog(LOG_INFO, "TMON caught signal %d\n", sig);
> >>> +	refresh();
> >>> +	switch (sig) {
> >>> +	case SIGTERM:
> >>> +		printf("sigterm, exit and clean up\n");
> >>> +		fflush(stdout);
> >>> +		break;
> >>> +	case SIGKILL:
> >>> +		printf("sigkill, exit and clean up\n");
> >>> +		fflush(stdout);
> >>> +		break;
> >>> +	case SIGINT:
> >>> +		printf("ctrl-c, exit and clean up\n");
> >>> +		fflush(stdout);
> >>> +		break;
> >>> +	default:
> >>> +		break;
> >>> +	}
> >>> +	tmon_exit =3D true;
> >>> +}
> >>> +
> >>> +
> >>> +static void start_syslog(void)
> >>> +{
> >>> +	if (debug_on)
> >>> +		setlogmask(LOG_UPTO(LOG_DEBUG));
> >>> +	else
> >>> +		setlogmask(LOG_UPTO(LOG_ERR));
> >>> +	openlog("tmon.log", LOG_CONS | LOG_PID | LOG_NDELAY,
> >>> LOG_LOCAL0);
> >>> +	syslog(LOG_NOTICE, "TMON started by User %d", getuid());
> >>> +}
> >>> +
> >>> +static void prepare_logging(void)
> >>> +{
> >>> +	int i;
> >>> +
> >>> +	if (!logging)
> >>> +		return;
> >>> +	/* open local data log file */
> >>> +	tmon_log =3D fopen(TMON_LOG_FILE, "w+");
> >>> +	if (!tmon_log) {
> >>> +		syslog(LOG_ERR, "failed to open log file %s\n",
> >>> TMON_LOG_FILE);
> >>> +		return;
> >>> +	}
> >>> +
> >>> +	fprintf(tmon_log, "#----------- THERMAL SYSTEM CONFIG
> >>> -------------\n");
> >>> +	for (i =3D 0; i < ptdata.nr_tz_sensor; i++) {
> >>> +		char binding_str[33]; /* size of long + 1 */
> >>> +		int j;
> >>> +
> >>> +		memset(binding_str, 0, sizeof(binding_str));
> >>> +		for (j =3D 0; j < 32; j++)
> >>> +			binding_str[j] =3D
> >>> (ptdata.tzi[i].cdev_binding & 1<<j) ?
> >>> +				'1' : '0';
> >>> +
> >>> +		fprintf(tmon_log, "#thermal zone %s%02d cdevs
> >>> binding: %32s\n",
> >>> +			ptdata.tzi[i].type,
> >>> +			ptdata.tzi[i].instance,
> >>> +			binding_str);
> >>> +		for (j =3D 0; j <	ptdata.tzi[i].nr_trip_pts;
> >>> j++) {
> >>> +			fprintf(tmon_log, "#\tTP%02d type:%s,
> >>> temp:%lu\n", j,
> >>> +
> >>> trip_type_name[ptdata.tzi[i].tp[j].type],
> >>> +				ptdata.tzi[i].tp[j].temp);
> >>> +		}
> >>> +
> >>> +	}
> >>> +
> >>> +	for (i =3D 0; i <	ptdata.nr_cooling_dev; i++)
> >>> +		fprintf(tmon_log, "#cooling devices%02d: %s\n",
> >>> +			i, ptdata.cdi[i].type);
> >>> +
> >>> +	fprintf(tmon_log, "#---------- THERMAL DATA LOG STARTED
> >>> -----------\n");
> >>> +	fprintf(tmon_log, "Samples TargetTemp ");
> >>> +	for (i =3D 0; i < ptdata.nr_tz_sensor; i++) {
> >>> +		fprintf(tmon_log, "%s%d    ", ptdata.tzi[i].type,
> >>> +			ptdata.tzi[i].instance);
> >>> +	}
> >>> +	for (i =3D 0; i <	ptdata.nr_cooling_dev; i++)
> >>> +		fprintf(tmon_log, "%s%d ", ptdata.cdi[i].type,
> >>> +			ptdata.cdi[i].instance);
> >>> +
> >>> +	fprintf(tmon_log, "\n");
> >>> +}
> >>> +
> >>> +static struct option opts[] =3D {
> >>> +	{ "control", 1, NULL, 'c' },
> >>> +	{ "daemon", 0, NULL, 'd' },
> >>> +	{ "time-interval", 1, NULL, 't' },
> >>> +	{ "log", 0, NULL, 'l' },
> >>> +	{ "help", 0, NULL, 'h' },
> >>> +	{ "version", 0, NULL, 'v' },
> >>> +	{ "debug", 0, NULL, 'g' },
> >>> +	{ 0, 0, NULL, 0 }
> >>> +};
> >>> +
> >>> +
> >>> +int main(int argc, char **argv)
> >>> +{
> >>> +	int err =3D 0;
> >>> +	int id2 =3D 0, c;
> >>> +	double yk =3D 0.0; /* controller output */
> >>> +	int target_tz_index;
> >>> +
> >>> +	if (geteuid() !=3D 0) {
> >>> +		printf("TMON needs to be run as root\n");
> >>> +		exit(EXIT_FAILURE);
> >>> +	}
> >>> +
> >>> +	while ((c =3D getopt_long(argc, argv, "c:dlht:vgz:", opts,
> >>> &id2)) !=3D -1) {
> >>> +		switch (c) {
> >>> +		case 'c':
> >>> +			no_control =3D 0;
> >>> +			strncpy(ctrl_cdev, optarg,
> >>> CDEV_NAME_SIZE);
> >>> +			break;
> >>> +		case 'd':
> >>> +			start_daemon_mode();
> >>> +			printf("Run TMON in daemon mode\n");
> >>> +			break;
> >>> +		case 't':
> >>> +			ticktime =3D strtod(optarg, NULL);
> >>> +			if (ticktime < 1)
> >>> +				ticktime =3D 1;
> >>> +			break;
> >>> +		case 'l':
> >>> +			printf("Logging data
> >>> to /var/tmp/tmon.log\n");
> >>> +			logging =3D 1;
> >>> +			break;
> >>> +		case 'h':
> >>> +			usage();
> >>> +			break;
> >>> +		case 'v':
> >>> +			version();
> >>> +			break;
> >>> +		case 'g':
> >>> +			debug_on =3D 1;
> >>> +			break;
> >>> +		case 'z':
> >>> +			target_thermal_zone =3D strtod(optarg,
> >>> NULL);
> >>> +			break;
> >>> +		default:
> >>> +			break;
> >>> +		}
> >>> +	}
> >>> +	if (pthread_mutex_init(&input_lock, NULL) !=3D 0) {
> >>> +		printf("\n mutex init failed\n");
> >>> +		return 1;
> >>> +	}
> >>> +	start_syslog();
> >>> +	if (signal(SIGINT, tmon_sig_handler) =3D=3D SIG_ERR)
> >>> +		syslog(LOG_DEBUG, "Cannot handle SIGINT\n");
> >>> +	if (signal(SIGTERM, tmon_sig_handler) =3D=3D SIG_ERR)
> >>> +		syslog(LOG_DEBUG, "Cannot handle SIGINT\n");
> >>> +
> >>> +	if (probe_thermal_sysfs()) {
> >>> +		closelog();
> >>> +		return -1;
> >>> +	}
> >>> +	initialize_curses();
> >>> +	setup_windows();
> >>> +	signal(SIGWINCH, resize_handler);
> >>> +	show_title_bar();
> >>> +	show_sensors_w();
> >>> +	show_cooling_device();
> >>> +	update_thermal_data();
> >>> +	show_data_w();
> >>> +	prepare_logging();
> >>> +	init_thermal_controller();
> >>> +
> >>> +	nodelay(stdscr, TRUE);
> >>> +	err =3D pthread_create(&event_tid, NULL,
> >>> &handle_tui_events, NULL);
> >>> +	if (err !=3D 0) {
> >>> +		printf("\ncan't create thread :[%s]",
> >>> strerror(err));
> >>> +		tmon_cleanup();
> >>> +		exit(EXIT_FAILURE);
> >>> +	}
> >>> +
> >>> +	/* validate range of user selected target zone, default
> >>> to the first
> >>> +	 * instance if out of range
> >>> +	 */
> >>> +	target_tz_index =3D
> >>> zone_instance_to_index(target_thermal_zone);
> >>> +	if (target_tz_index < 0) {
> >>> +		target_thermal_zone =3D ptdata.tzi[0].instance;
> >>> +		syslog(LOG_ERR, "target zone is not found,
> >>> default to %d\n",
> >>> +			target_thermal_zone);
> >>> +	}
> >>> +	while (1) {
> >>> +		sleep(ticktime);
> >>> +		show_title_bar();
> >>> +		show_sensors_w();
> >>> +		update_thermal_data();
> >>> +		if (!dialogue_on) {
> >>> +			show_data_w();
> >>> +			show_cooling_device();
> >>> +		}
> >>> +		cur_thermal_record++;
> >>> +		time_elapsed +=3D ticktime;
> >>> +
> >>> controller_handler(trec[0].temp[target_tz_index] / 1000,
> >>> +				&yk);
> >>> +		trec[0].pid_out_pct =3D yk;
> >>> +		if (!dialogue_on)
> >>> +			show_control_w();
> >>> +		if (tmon_exit)
> >>> +			break;
> >>> +	}
> >>> +	tmon_cleanup();
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static void start_daemon_mode()
> >>> +{
> >>> +	daemon_mode =3D 1;
> >>> +	/* fork */
> >>> +	pid_t	sid, pid =3D fork();
> >>> +	if (pid < 0) {
> >>> +		exit(EXIT_FAILURE);
> >>> +	} else if (pid > 0)
> >>> +		/* kill parent */
> >>> +		exit(EXIT_SUCCESS);
> >>> +
> >>> +	/* disable TUI, it may not be necessary, but saves some
> >>> resource */
> >>> +	disable_tui();
> >>> +
> >>> +	/* change the file mode mask */
> >>> +	umask(0);
> >>> +
> >>> +	/* new SID for the daemon process */
> >>> +	sid =3D setsid();
> >>> +	if (sid < 0)
> >>> +		exit(EXIT_FAILURE);
> >>> +
> >>> +	/* change working directory */
> >>> +	if ((chdir("/")) < 0)
> >>> +		exit(EXIT_FAILURE);
> >>> +
> >>> +
> >>> +	sleep(10);
> >>> +
> >>> +	close(STDIN_FILENO);
> >>> +	close(STDOUT_FILENO);
> >>> +	close(STDERR_FILENO);
> >>> +
> >>> +}
> >>> diff --git a/tools/thermal/tmon/tmon.h b/tools/thermal/tmon/tmon.h
> >>> new file mode 100644
> >>> index 0000000..9e3c49c
> >>> --- /dev/null
> >>> +++ b/tools/thermal/tmon/tmon.h
> >>> @@ -0,0 +1,204 @@
> >>> +/*
> >>> + * tmon.h contains data structures and constants used by TMON
> >>> + *
> >>> + * Copyright (C) 2012 Intel Corporation. All rights reserved.
> >>> + *
> >>> + * This program is free software; you can redistribute it and/or
> >>> + * modify it under the terms of the GNU General Public License
> >>> version
> >>> + * 2 or later as published by the Free Software Foundation.
> >>> + *
> >>> + * This program is distributed in the hope that it will be
> >>> useful,
> >>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>> + * GNU General Public License for more details.
> >>> + *
> >>> + * Author Name Jacob Pan <jacob.jun.pan@linux.intel.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#ifndef TMON_H
> >>> +#define TMON_H
> >>> +
> >>> +#define MAX_DISP_TEMP 125
> >>> +#define MAX_CTRL_TEMP 105
> >>> +#define MIN_CTRL_TEMP 40
> >>> +#define MAX_NR_TZONE 16
> >>> +#define MAX_NR_CDEV 32
> >>> +#define MAX_NR_TRIP 16
> >>> +#define MAX_NR_CDEV_TRIP 12 /* number of cooling devices that can
> >>> bind
> >>> +			     * to a thermal zone trip.
> >>> +			     */
> >>> +#define MAX_TEMP_KC 140000
> >>> +/* starting char position to draw sensor data, such as tz names
> >>> + * trip point list, etc.
> >>> + */
> >>> +#define DATA_LEFT_ALIGN 10
> >>> +#define NR_LINES_TZDATA 1
> >>> +#define TMON_LOG_FILE "/var/tmp/tmon.log"
> >>> +
> >>> +extern unsigned long ticktime;
> >>> +extern double time_elapsed;
> >>> +extern unsigned long target_temp_user;
> >>> +extern int dialogue_on;
> >>> +extern char ctrl_cdev[];
> >>> +extern pthread_mutex_t input_lock;
> >>> +extern int tmon_exit;
> >>> +extern int target_thermal_zone;
> >>> +/* use fixed size record to simplify data processing and transfer
> >>> + * TBD: more info to be added, e.g. programmable trip point data.
> >>> +*/
> >>> +struct thermal_data_record {
> >>> +	struct timeval tv;
> >>> +	unsigned long temp[MAX_NR_TZONE];
> >>> +	double pid_out_pct;
> >>> +};
> >>> +
> >>> +struct cdev_info {
> >>> +	char type[64];
> >>> +	int instance;
> >>> +	unsigned long max_state;
> >>> +	unsigned long cur_state;
> >>> +	unsigned long flag;
> >>> +};
> >>> +
> >>> +enum trip_type {
> >>> +	THERMAL_TRIP_CRITICAL,
> >>> +	THERMAL_TRIP_HOT,
> >>> +	THERMAL_TRIP_PASSIVE,
> >>> +	THERMAL_TRIP_ACTIVE,
> >>> +	NR_THERMAL_TRIP_TYPE,
> >>> +};
> >>> +
> >>> +struct trip_point {
> >>> +	enum trip_type type;
> >>> +	unsigned long temp;
> >>> +	unsigned long hysteresis;
> >>> +	int attribute; /* programmability etc. */
> >>> +};
> >>> +
> >>> +/* thermal zone configuration information, binding with cooling
> >>> devices could
> >>> + * change at runtime.
> >>> + */
> >>> +struct tz_info {
> >>> +	char type[256]; /* e.g. acpitz */
> >>> +	int instance;
> >>> +	int passive; /* active zone has passive node to force
> >>> passive mode */
> >>> +	int nr_cdev; /* number of cooling device binded */
> >>> +	int nr_trip_pts;
> >>> +	struct trip_point tp[MAX_NR_TRIP];
> >>> +	unsigned long cdev_binding; /* bitmap for attached cdevs
> >>> */
> >>> +	/* cdev bind trip points, allow one cdev bind to multiple
> >>> trips */
> >>> +	unsigned long trip_binding[MAX_NR_CDEV];
> >>> +};
> >>> +
> >>> +struct tmon_platform_data {
> >>> +	int nr_tz_sensor;
> >>> +	int nr_cooling_dev;
> >>> +	/* keep track of instance ids since there might be gaps
> >>> */
> >>> +	int max_tz_instance;
> >>> +	int max_cdev_instance;
> >>> +	struct tz_info *tzi;
> >>> +	struct cdev_info *cdi;
> >>> +};
> >>> +
> >>> +struct control_ops {
> >>> +	void (*set_ratio)(unsigned long ratio);
> >>> +	unsigned long (*get_ratio)(unsigned long ratio);
> >>> +
> >>> +};
> >>> +
> >>> +enum cdev_types {
> >>> +	CDEV_TYPE_PROC,
> >>> +	CDEV_TYPE_FAN,
> >>> +	CDEV_TYPE_MEM,
> >>> +	CDEV_TYPE_NR,
> >>> +};
> >>> +
> >>> +/* REVISIT: the idea is to group sensors if possible, e.g. on
> >>> intel mid
> >>> + * we have "skin0", "skin1", "sys", "msicdie"
> >>> + * on DPTF enabled systems, we might have PCH, TSKN, TAMB, etc.
> >>> + */
> >>> +enum tzone_types {
> >>> +	TZONE_TYPE_ACPI,
> >>> +	TZONE_TYPE_PCH,
> >>> +	TZONE_TYPE_NR,
> >>> +};
> >>> +
> >>> +/* limit the output of PID controller adjustment */
> >>> +#define LIMIT_HIGH (95)
> >>> +#define LIMIT_LOW  (2)
> >>> +
> >>> +struct pid_params {
> >>> +	double kp;  /* Controller gain from Dialog Box */
> >>> +	double ki;  /* Time-constant for I action from Dialog Box
> >>> */
> >>> +	double kd;  /* Time-constant for D action from Dialog Box
> >>> */
> >>> +	double ts;
> >>> +	double k_lpf;
> >>> +
> >>> +	double t_target;
> >>> +	double y_k;
> >>> +};
> >>> +
> >>> +extern int init_thermal_controller(void);
> >>> +extern void controller_handler(const double xk, double *yk);
> >>> +
> >>> +extern struct tmon_platform_data ptdata;
> >>> +extern struct pid_params p_param;
> >>> +
> >>> +extern FILE *tmon_log;
> >>> +extern int cur_thermal_record; /* index to the trec array */
> >>> +extern struct thermal_data_record trec[];
> >>> +extern const char *trip_type_name[];
> >>> +extern unsigned long no_control;
> >>> +
> >>> +extern void initialize_curses(void);
> >>> +extern void show_controller_stats(char *line);
> >>> +extern void show_title_bar(void);
> >>> +extern void setup_windows(void);
> >>> +extern void disable_tui(void);
> >>> +extern void show_sensors_w(void);
> >>> +extern void show_data_w(void);
> >>> +extern void write_status_bar(int x, char *line);
> >>> +extern void show_control_w();
> >>> +
> >>> +extern void show_cooling_device(void);
> >>> +extern void show_dialogue(void);
> >>> +extern int update_thermal_data(void);
> >>> +
> >>> +extern int probe_thermal_sysfs(void);
> >>> +extern void free_thermal_data(void);
> >>> +extern	void resize_handler(int sig);
> >>> +extern void set_ctrl_state(unsigned long state);
> >>> +extern void get_ctrl_state(unsigned long *state);
> >>> +extern void *handle_tui_events(void *arg);
> >>> +extern int sysfs_set_ulong(char *path, char *filename, unsigned
> >>> long val); +extern int zone_instance_to_index(int zone_inst);
> >>> +extern void close_windows(void);
> >>> +
> >>> +#define PT_COLOR_DEFAULT    1
> >>> +#define PT_COLOR_HEADER_BAR 2
> >>> +#define PT_COLOR_ERROR      3
> >>> +#define PT_COLOR_RED        4
> >>> +#define PT_COLOR_YELLOW     5
> >>> +#define PT_COLOR_GREEN      6
> >>> +#define PT_COLOR_BRIGHT     7
> >>> +#define PT_COLOR_BLUE	    8
> >>> +
> >>> +/* each thermal zone uses 12 chars, 8 for name, 2 for instance, 2
> >>> space
> >>> + * also used to list trip points in forms of AAAC, which
> >>> represents
> >>> + * A: Active
> >>> + * C: Critical
> >>> + */
> >>> +#define TZONE_RECORD_SIZE 12
> >>> +#define TZ_LEFT_ALIGN 32
> >>> +#define CDEV_NAME_SIZE 20
> >>> +#define CDEV_FLAG_IN_CONTROL (1 << 0)
> >>> +
> >>> +/* dialogue box starts */
> >>> +#define DIAG_X 48
> >>> +#define DIAG_Y 8
> >>> +#define THERMAL_SYSFS "/sys/class/thermal"
> >>> +#define CDEV "cooling_device"
> >>> +#define TZONE "thermal_zone"
> >>> +#define TDATA_LEFT 16
> >>> +#endif /* TMON_H */
> >>> diff --git a/tools/thermal/tmon/tui.c b/tools/thermal/tmon/tui.c
> >>> new file mode 100644
> >>> index 0000000..957ecf3
> >>> --- /dev/null
> >>> +++ b/tools/thermal/tmon/tui.c
> >>> @@ -0,0 +1,631 @@
> >>> +/*
> >>> + * tui.c ncurses text user interface for TMON program
> >>> + *
> >>> + * Copyright (C) 2013 Intel Corporation. All rights reserved.
> >>> + *
> >>> + * This program is free software; you can redistribute it and/or
> >>> + * modify it under the terms of the GNU General Public License
> >>> version
> >>> + * 2 or later as published by the Free Software Foundation.
> >>> + *
> >>> + * This program is distributed in the hope that it will be
> >>> useful,
> >>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>> + * GNU General Public License for more details.
> >>> + *
> >>> + * Author: Jacob Pan <jacob.jun.pan@linux.intel.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#include <unistd.h>
> >>> +#include <stdio.h>
> >>> +#include <stdlib.h>
> >>> +#include <string.h>
> >>> +#include <stdint.h>
> >>> +#include <ncurses.h>
> >>> +#include <time.h>
> >>> +#include <syslog.h>
> >>> +#include <panel.h>
> >>> +#include <pthread.h>
> >>> +#include <signal.h>
> >>> +
> >>> +#include "tmon.h"
> >>> +
> >>> +static PANEL *data_panel;
> >>> +static PANEL *dialogue_panel;
> >>> +static PANEL *top;
> >>> +
> >>> +static WINDOW *title_bar_window;
> >>> +static WINDOW *tz_sensor_window;
> >>> +static WINDOW *cooling_device_window;
> >>> +static WINDOW *control_window;
> >>> +static WINDOW *status_bar_window;
> >>> +static WINDOW *thermal_data_window;
> >>> +static WINDOW *dialogue_window;
> >>> +
> >>> +char status_bar_slots[10][40];
> >>> +static void draw_hbar(WINDOW *win, int y, int start, int len,
> >>> +		unsigned long pattern, bool end);
> >>> +
> >>> +static int maxx, maxy;
> >>> +static int maxwidth =3D 200;
> >>> +
> >>> +#define TITLE_BAR_HIGHT 1
> >>> +#define SENSOR_WIN_HIGHT 4 /* one row for tz name, one for trip
> >>> points */ +
> >>> +
> >>> +/* daemon mode flag (set by startup parameter -d) */
> >>> +static int  tui_disabled;
> >>> +
> >>> +static void close_panel(PANEL *p)
> >>> +{
> >>> +	if (p) {
> >>> +		del_panel(p);
> >>> +		p =3D NULL;
> >>> +	}
> >>> +}
> >>> +
> >>> +static void close_window(WINDOW *win)
> >>> +{
> >>> +	if (win) {
> >>> +		delwin(win);
> >>> +		win =3D NULL;
> >>> +	}
> >>> +}
> >>> +
> >>> +void close_windows(void)
> >>> +{
> >>> +	if (tui_disabled)
> >>> +		return;
> >>> +	/* must delete panels before their attached windows */
> >>> +	if (dialogue_window)
> >>> +		close_panel(dialogue_panel);
> >>> +	if (cooling_device_window)
> >>> +		close_panel(data_panel);
> >>> +
> >>> +	close_window(title_bar_window);
> >>> +	close_window(tz_sensor_window);
> >>> +	close_window(status_bar_window);
> >>> +	close_window(cooling_device_window);
> >>> +	close_window(control_window);
> >>> +	close_window(thermal_data_window);
> >>> +	close_window(dialogue_window);
> >>> +
> >>> +}
> >>> +
> >>> +void write_status_bar(int x, char *line)
> >>> +{
> >>> +	mvwprintw(status_bar_window, 0, x, "%s", line);
> >>> +	wrefresh(status_bar_window);
> >>> +}
> >>> +
> >>> +void setup_windows(void)
> >>> +{
> >>> +	int y_begin =3D 1;
> >>> +
> >>> +	if (tui_disabled)
> >>> +		return;
> >>> +
> >>> +	getmaxyx(stdscr, maxy, maxx);
> >>> +	resizeterm(maxy, maxx);
> >>> +
> >>> +	title_bar_window =3D subwin(stdscr, TITLE_BAR_HIGHT, maxx,
> >>> 0, 0);
> >>> +	y_begin +=3D TITLE_BAR_HIGHT;
> >>> +
> >>> +	tz_sensor_window =3D subwin(stdscr, SENSOR_WIN_HIGHT, maxx,
> >>> y_begin, 0);
> >>> +	y_begin +=3D SENSOR_WIN_HIGHT;
> >>> +
> >>> +	cooling_device_window =3D subwin(stdscr,
> >>> ptdata.nr_cooling_dev + 3, maxx,
> >>> +				y_begin, 0);
> >>> +	y_begin +=3D ptdata.nr_cooling_dev + 3; /* 2 lines for
> >>> border */
> >>> +	/* two lines to show borders, one line per tz show trip
> >>> point position
> >>> +	 * and value.
> >>> +	 * dialogue window is a pop-up, when needed it lays on
> >>> top of cdev win
> >>> +	 */
> >>> +
> >>> +	dialogue_window =3D subwin(stdscr, ptdata.nr_cooling_dev+5,
> >>> maxx-50,
> >>> +				DIAG_Y, DIAG_X);
> >>> +
> >>> +	thermal_data_window =3D subwin(stdscr, ptdata.nr_tz_sensor
> >>> *
> >>> +				NR_LINES_TZDATA + 3, maxx,
> >>> y_begin, 0);
> >>> +	y_begin +=3D ptdata.nr_tz_sensor * NR_LINES_TZDATA + 3;
> >>> +	control_window =3D subwin(stdscr, 4, maxx, y_begin, 0);
> >>> +
> >>> +	scrollok(cooling_device_window, TRUE);
> >>> +	maxwidth =3D maxx - 18;
> >>> +	status_bar_window =3D subwin(stdscr, 1, maxx, maxy-1, 0);
> >>> +
> >>> +	strcpy(status_bar_slots[0], " Ctrl-c - Quit ");
> >>> +	strcpy(status_bar_slots[1], " TAB - Tuning ");
> >>> +	wmove(status_bar_window, 1, 30);
> >>> +
> >>> +	/* prepare panels for dialogue, if panel already created
> >>> then we must
> >>> +	 * be doing resizing, so just replace windows with new
> >>> ones, old ones
> >>> +	 * should have been deleted by close_window
> >>> +	 */
> >>> +	data_panel =3D new_panel(cooling_device_window);
> >>> +	if (!data_panel)
> >>> +		syslog(LOG_DEBUG, "No data panel\n");
> >>> +	else {
> >>> +		if (dialogue_window) {
> >>> +			dialogue_panel =3D
> >>> new_panel(dialogue_window);
> >>> +			if (!dialogue_panel)
> >>> +				syslog(LOG_DEBUG, "No dialogue
> >>> panel\n");
> >>> +			else {
> >>> +				/* Set up the user pointer to the
> >>> next panel*/
> >>> +				set_panel_userptr(data_panel,
> >>> dialogue_panel);
> >>> +				set_panel_userptr(dialogue_panel,
> >>> data_panel);
> >>> +				top =3D data_panel;
> >>> +			}
> >>> +		} else
> >>> +			syslog(LOG_INFO, "no dialogue win, term
> >>> too small\n");
> >>> +	}
> >>> +	doupdate();
> >>> +	werase(stdscr);
> >>> +	refresh();
> >>> +}
> >>> +
> >>> +void resize_handler(int sig)
> >>> +{
> >>> +	/* start over when term gets resized, but first we clean
> >>> up */
> >>> +	close_windows();
> >>> +	endwin();
> >>> +	refresh();
> >>> +	clear();
> >>> +	getmaxyx(stdscr, maxy, maxx);  /* get the new screen size
> >>> */
> >>> +	setup_windows();
> >>> +	/* rate limit */
> >>> +	sleep(1);
> >>> +	syslog(LOG_DEBUG, "SIG %d, term resized to %d x %d\n",
> >>> +		sig, maxy, maxx);
> >>> +	signal(SIGWINCH, resize_handler);
> >>> +}
> >>> +
> >>> +const char cdev_title[] =3D " COOLING DEVICES ";
> >>> +void show_cooling_device(void)
> >>> +{
> >>> +	int i, j, x, y =3D 0;
> >>> +
> >>> +	if (tui_disabled || !cooling_device_window)
> >>> +		return;
> >>> +
> >>> +	werase(cooling_device_window);
> >>> +
> >>> +	wattron(cooling_device_window, A_BOLD);
> >>> +	mvwprintw(cooling_device_window, 0, maxx/2 -
> >>> sizeof(cdev_title),
> >>> +		cdev_title);
> >>> +
> >>> +	mvwprintw(cooling_device_window,  1, 1,
> >>> +		"ID  Cooling Dev   Cur    Max   Thermal Zone
> >>> Binding");
> >>> +	wattroff(cooling_device_window, A_BOLD);
> >>> +	for (j =3D 0; j <	ptdata.nr_cooling_dev; j++) {
> >>> +		/* draw cooling device list on the left in the
> >>> order of
> >>> +		 * cooling device instances. skip unused idr.
> >>> +		 */
> >>> +		mvwprintw(cooling_device_window, j + 2, 1,
> >>> +			"%02d %12.12s%6d %6d",
> >>> +			ptdata.cdi[j].instance,
> >>> +			ptdata.cdi[j].type,
> >>> +			ptdata.cdi[j].cur_state,
> >>> +			ptdata.cdi[j].max_state);
> >>> +	}
> >>> +
> >>> +	/* show cdev binding, y is the global cooling device
> >>> instance */
> >>> +	for (i =3D 0; i < ptdata.nr_tz_sensor; i++) {
> >>> +		int tz_inst =3D ptdata.tzi[i].instance;
> >>> +		for (j =3D 0; j < ptdata.nr_cooling_dev; j++) {
> >>> +			int cdev_inst;
> >>> +			y =3D j;
> >>> +			x =3D tz_inst * TZONE_RECORD_SIZE +
> >>> TZ_LEFT_ALIGN; +
> >>> +			draw_hbar(cooling_device_window, y+2, x,
> >>> +				TZONE_RECORD_SIZE-1, ACS_VLINE,
> >>> false); +
> >>> +			/* draw a column of spaces to separate
> >>> thermal zones */
> >>> +			mvwprintw(cooling_device_window, y+2,
> >>> x-1, " ");
> >>> +			if (ptdata.tzi[i].cdev_binding) {
> >>> +				cdev_inst =3D
> >>> ptdata.cdi[j].instance;
> >>> +				unsigned long trip_binding =3D
> >>> +
> >>> ptdata.tzi[i].trip_binding[cdev_inst];
> >>> +				int k =3D 0; /* per zone trip point
> >>> id that
> >>> +					    * binded to this
> >>> cdev, one to
> >>> +					    * many possible based
> >>> on the
> >>> +					    * binding bitmask.
> >>> +					    */
> >>> +				syslog(LOG_DEBUG,
> >>> +					"bind tz%d cdev%d tp%lx
> >>> %d cdev%lx\n",
> >>> +					i, j, trip_binding, y,
> >>> +
> >>> ptdata.tzi[i].cdev_binding);
> >>> +				/* draw each trip binding for the
> >>> cdev */
> >>> +				while (trip_binding >>=3D 1) {
> >>> +					k++;
> >>> +					if (!(trip_binding & 1))
> >>> +						continue;
> >>> +					/* draw '*' to show
> >>> binding */
> >>> +
> >>> mvwprintw(cooling_device_window,
> >>> +						y + 2,
> >>> +						x +
> >>> ptdata.tzi[i].nr_trip_pts -
> >>> +						k - 1, "*");
> >>> +				}
> >>> +			}
> >>> +		}
> >>> +	}
> >>> +	wborder(cooling_device_window, 0, 0, 0, 0, 0, 0, 0, 0);
> >>> +	wrefresh(cooling_device_window);
> >>> +}
> >>> +
> >>> +const char DIAG_TITLE[] =3D "[ TUNABLES ]";
> >>> +#define DIAG_DEV_ROWS  5
> >>> +void show_dialogue(void)
> >>> +{
> >>> +	int j, x =3D 0, y =3D 0;
> >>> +	WINDOW *w =3D dialogue_window;
> >>> +
> >>> +	if (tui_disabled || !w)
> >>> +		return;
> >>> +
> >>> +	werase(w);
> >>> +	box(w, 0, 0);
> >>> +	mvwprintw(w, 0, maxx/4, DIAG_TITLE);
> >>> +	/* list all the available tunables */
> >>> +	for (j =3D 0; j <=3D ptdata.nr_cooling_dev; j++) {
> >>> +		y =3D j % DIAG_DEV_ROWS;
> >>> +		if (y =3D=3D 0 && j !=3D 0)
> >>> +			x +=3D 20;
> >>> +		if (j =3D=3D ptdata.nr_cooling_dev)
> >>> +			/* save last choice for target temp */
> >>> +			mvwprintw(w, y+1, x+1, "%C-%.12s", 'A'+j,
> >>> "Set Temp");
> >>> +		else
> >>> +			mvwprintw(w, y+1, x+1, "%C-%.10s-%2d",
> >>> 'A'+j,
> >>> +				ptdata.cdi[j].type,
> >>> ptdata.cdi[j].instance);
> >>> +	}
> >>> +	wattron(w, A_BOLD);
> >>> +	mvwprintw(w, DIAG_DEV_ROWS+1, 1, "Enter Choice [A-Z]?");
> >>> +	wattroff(w, A_BOLD);
> >>> +	/* y size of dialogue win is nr cdev + 5, so print legend
> >>> +	 * at the bottom line
> >>> +	 */
> >>> +	mvwprintw(w, ptdata.nr_cooling_dev+3, 1,
> >>> +		"Legend: A=3DActive, P=3DPassive, C=3DCritical");
> >>> +
> >>> +	wrefresh(dialogue_window);
> >>> +}
> >>> +
> >>> +void write_dialogue_win(char *buf, int y, int x)
> >>> +{
> >>> +	WINDOW *w =3D dialogue_window;
> >>> +
> >>> +	mvwprintw(w, y, x, "%s", buf);
> >>> +}
> >>> +
> >>> +const char control_title[] =3D " CONTROLS ";
> >>> +void show_control_w(void)
> >>> +{
> >>> +	unsigned long state;
> >>> +
> >>> +	get_ctrl_state(&state);
> >>> +
> >>> +	if (tui_disabled || !control_window)
> >>> +		return;
> >>> +
> >>> +	werase(control_window);
> >>> +	wattron(control_window, A_BOLD);
> >>> +	mvwprintw(control_window, 0, maxx/2 -
> >>> sizeof(control_title),
> >>> +		control_title);
> >>> +	wattroff(control_window, A_BOLD);
> >>> +
> >>> +	mvwprintw(control_window, 1, 1, "PID gain: kp=3D%2.2f
> >>> ki=3D%2.2f, kd=3D%2.2f",
> >>> +		p_param.kp, p_param.ki, p_param.kd);
> >>> +
> >>> +	mvwprintw(control_window, 2, 1,
> >>> +		"Target Temp: %2.1f, Zone: %d, Control Device:
> >>> %.12s, PID output: %2.2f, state: %d",
> >>> +		target_thermal_zone, ctrl_cdev,
> >>> +		p_param.t_target, p_param.y_k, state);
> >>> +	/* draw border last such that everything is within
> >>> boundary */
> >>> +	wborder(control_window, 0, 0, 0, 0, 0, 0, 0, 0);
> >>> +	wrefresh(control_window);
> >>> +}
> >>> +
> >>> +void initialize_curses(void)
> >>> +{
> >>> +	if (tui_disabled)
> >>> +		return;
> >>> +
> >>> +	initscr();
> >>> +	start_color();
> >>> +	keypad(stdscr, TRUE);	/* enable keyboard mapping
> >>> */
> >>> +	nonl();			/* tell curses not to do
> >>> NL->CR/NL on output */
> >>> +	cbreak();		/* take input chars one at a
> >>> time */
> >>> +	noecho();		/* dont echo input */
> >>> +	curs_set(0);		/* turn off cursor */
> >>> +	use_default_colors();
> >>> +
> >>> +	init_pair(PT_COLOR_DEFAULT, COLOR_WHITE, COLOR_BLACK);
> >>> +	init_pair(PT_COLOR_HEADER_BAR, COLOR_BLACK, COLOR_WHITE);
> >>> +	init_pair(PT_COLOR_ERROR, COLOR_BLACK, COLOR_RED);
> >>> +	init_pair(PT_COLOR_RED, COLOR_WHITE, COLOR_RED);
> >>> +	init_pair(PT_COLOR_YELLOW, COLOR_WHITE, COLOR_YELLOW);
> >>> +	init_pair(PT_COLOR_GREEN, COLOR_WHITE, COLOR_GREEN);
> >>> +	init_pair(PT_COLOR_BLUE, COLOR_WHITE, COLOR_BLUE);
> >>> +	init_pair(PT_COLOR_BRIGHT, COLOR_WHITE, COLOR_BLACK);
> >>> +
> >>> +}
> >>> +
> >>> +void show_title_bar(void)
> >>> +{
> >>> +	int i;
> >>> +	int x =3D 0;
> >>> +
> >>> +	if (tui_disabled || !title_bar_window)
> >>> +		return;
> >>> +
> >>> +	wattrset(title_bar_window,
> >>> COLOR_PAIR(PT_COLOR_HEADER_BAR));
> >>> +	wbkgd(title_bar_window, COLOR_PAIR(PT_COLOR_HEADER_BAR));
> >>> +	werase(title_bar_window);
> >>> +
> >>> +	mvwprintw(title_bar_window, 0, 0,
> >>> +		"     TMON v%s", VERSION);
> >>> +
> >>> +	wrefresh(title_bar_window);
> >>> +
> >>> +	werase(status_bar_window);
> >>> +
> >>> +	for (i =3D 0; i < 10; i++) {
> >>> +		if (strlen(status_bar_slots[i]) =3D=3D 0)
> >>> +			continue;
> >>> +		wattron(status_bar_window, A_REVERSE);
> >>> +		mvwprintw(status_bar_window, 0, x, "%s",
> >>> status_bar_slots[i]);
> >>> +		wattroff(status_bar_window, A_REVERSE);
> >>> +		x +=3D strlen(status_bar_slots[i]) + 1;
> >>> +	}
> >>> +	wrefresh(status_bar_window);
> >>> +}
> >>> +
> >>> +static void handle_input_val(int ch)
> >>> +{
> >>> +	char buf[32];
> >>> +	int val;
> >>> +	char path[256];
> >>> +	WINDOW *w =3D dialogue_window;
> >>> +
> >>> +	echo();
> >>> +	keypad(w, TRUE);
> >>> +	wgetnstr(w, buf, 31);
> >>> +	val =3D atoi(buf);
> >>> +
> >>> +	if (ch =3D=3D ptdata.nr_cooling_dev) {
> >>> +		snprintf(buf, 31, "Invalid Temp %d! %d-%d", val,
> >>> +			MIN_CTRL_TEMP, MAX_CTRL_TEMP);
> >>> +		if (val < MIN_CTRL_TEMP || val > MAX_CTRL_TEMP)
> >>> +			write_status_bar(40, buf);
> >>> +		else {
> >>> +			p_param.t_target =3D val;
> >>> +			snprintf(buf, 31, "Set New Target Temp
> >>> %d", val);
> >>> +			write_status_bar(40, buf);
> >>> +		}
> >>> +	} else {
> >>> +		snprintf(path, 256, "%s/%s%d", THERMAL_SYSFS,
> >>> +			CDEV, ptdata.cdi[ch].instance);
> >>> +		sysfs_set_ulong(path, "cur_state", val);
> >>> +	}
> >>> +	noecho();
> >>> +	dialogue_on =3D 0;
> >>> +	show_data_w();
> >>> +	show_control_w();
> >>> +
> >>> +	top =3D (PANEL *)panel_userptr(top);
> >>> +	top_panel(top);
> >>> +}
> >>> +
> >>> +static void handle_input_choice(int ch)
> >>> +{
> >>> +	char buf[48];
> >>> +	int base =3D 0;
> >>> +	int cdev_id =3D 0;
> >>> +
> >>> +	if ((ch >=3D 'A' && ch <=3D 'A' + ptdata.nr_cooling_dev) ||
> >>> +		(ch >=3D 'a' && ch <=3D 'a' +
> >>> ptdata.nr_cooling_dev)) {
> >>> +		base =3D (ch < 'a') ? 'A' : 'a';
> >>> +		cdev_id =3D ch - base;
> >>> +		if (ptdata.nr_cooling_dev =3D=3D cdev_id)
> >>> +			snprintf(buf, sizeof(buf), "New Target
> >>> Temp:");
> >>> +		else
> >>> +			snprintf(buf, sizeof(buf), "New Value for
> >>> %.10s-%2d: ",
> >>> +				ptdata.cdi[cdev_id].type,
> >>> +				ptdata.cdi[cdev_id].instance);
> >>> +		write_dialogue_win(buf, DIAG_DEV_ROWS+2, 2);
> >>> +		handle_input_val(cdev_id);
> >>> +	} else {
> >>> +		snprintf(buf, sizeof(buf), "Invalid selection
> >>> %d", ch);
> >>> +		write_dialogue_win(buf, 8, 2);
> >>> +	}
> >>> +}
> >>> +
> >>> +void *handle_tui_events(void *arg)
> >>> +{
> >>> +	int ch;
> >>> +
> >>> +	keypad(cooling_device_window, TRUE);
> >>> +	while ((ch =3D wgetch(cooling_device_window)) !=3D EOF) {
> >>> +		if (tmon_exit)
> >>> +			break;
> >>> +		/* when term size is too small, no dialogue
> >>> panels are set.
> >>> +		 * we need to filter out such cases.
> >>> +		 */
> >>> +		if (!data_panel || !dialogue_panel ||
> >>> +			!cooling_device_window ||
> >>> +			!dialogue_window) {
> >>> +
> >>> +			continue;
> >>> +		}
> >>> +		pthread_mutex_lock(&input_lock);
> >>> +		if (dialogue_on) {
> >>> +			handle_input_choice(ch);
> >>> +			/* top panel filter */
> >>> +			if (ch =3D=3D 'q' || ch =3D=3D 'Q')
> >>> +				ch =3D 0;
> >>> +		}
> >>> +		switch (ch) {
> >>> +		case KEY_LEFT:
> >>> +			box(cooling_device_window, 10, 0);
> >>> +			break;
> >>> +		case 9: /* TAB */
> >>> +			top =3D (PANEL *)panel_userptr(top);
> >>> +			top_panel(top);
> >>> +			if (top =3D=3D dialogue_panel) {
> >>> +				dialogue_on =3D 1;
> >>> +				show_dialogue();
> >>> +			} else {
> >>> +				dialogue_on =3D 0;
> >>> +				/* force refresh */
> >>> +				show_data_w();
> >>> +				show_control_w();
> >>> +			}
> >>> +			break;
> >>> +		case 'q':
> >>> +		case 'Q':
> >>> +			tmon_exit =3D 1;
> >>> +			break;
> >>> +		}
> >>> +		update_panels();
> >>> +		doupdate();
> >>> +		pthread_mutex_unlock(&input_lock);
> >>> +	}
> >>> +
> >>> +	if (arg)
> >>> +		*(int *)arg =3D 0; /* make gcc happy */
> >>> +
> >>> +	return NULL;
> >>> +}
> >>> +
> >>> +/* draw a horizontal bar in given pattern */
> >>> +static void draw_hbar(WINDOW *win, int y, int start, int len,
> >>> unsigned long ptn,
> >>> +		bool end)
> >>> +{
> >>> +	mvwaddch(win, y, start, ptn);
> >>> +	whline(win, ptn, len);
> >>> +	if (end)
> >>> +		mvwaddch(win, y, MAX_DISP_TEMP+TDATA_LEFT, ']');
> >>> +}
> >>> +
> >>> +static char trip_type_to_char(int type)
> >>> +{
> >>> +	switch (type) {
> >>> +	case THERMAL_TRIP_CRITICAL: return 'C';
> >>> +	case THERMAL_TRIP_HOT: return 'H';
> >>> +	case THERMAL_TRIP_PASSIVE: return 'P';
> >>> +	case THERMAL_TRIP_ACTIVE: return 'A';
> >>> +	default:
> >>> +		return '?';
> >>> +	}
> >>> +}
> >>> +
> >>> +/* fill a string with trip point type and value in one line
> >>> + * e.g.      P(56)    C(106)
> >>> + * maintain the distance one degree per char
> >>> + */
> >>> +static void draw_tp_line(int tz, int y)
> >>> +{
> >>> +	int j;
> >>> +	int x;
> >>> +
> >>> +	for (j =3D 0; j < ptdata.tzi[tz].nr_trip_pts; j++) {
> >>> +		x =3D ptdata.tzi[tz].tp[j].temp / 1000;
> >>> +		mvwprintw(thermal_data_window, y + 0, x +
> >>> TDATA_LEFT,
> >>> +			"%c%d",
> >>> trip_type_to_char(ptdata.tzi[tz].tp[j].type),
> >>> +			x);
> >>> +		syslog(LOG_INFO, "%s:tz %d tp %d temp =3D %lu\n",
> >>> __func__,
> >>> +			tz, j, ptdata.tzi[tz].tp[j].temp);
> >>> +	}
> >>> +}
> >>> +
> >>> +const char data_win_title[] =3D " THERMAL DATA ";
> >>> +void show_data_w(void)
> >>> +{
> >>> +	int i;
> >>> +
> >>> +
> >>> +	if (tui_disabled || !thermal_data_window)
> >>> +		return;
> >>> +
> >>> +	werase(thermal_data_window);
> >>> +	wattron(thermal_data_window, A_BOLD);
> >>> +	mvwprintw(thermal_data_window, 0, maxx/2 -
> >>> sizeof(data_win_title),
> >>> +		data_win_title);
> >>> +	wattroff(thermal_data_window, A_BOLD);
> >>> +	/* draw a line as ruler */
> >>> +	for (i =3D 10; i < MAX_DISP_TEMP; i +=3D 10)
> >>> +		mvwprintw(thermal_data_window, 1, i+TDATA_LEFT,
> >>> "%2d", i); +
> >>> +	for (i =3D 0; i < ptdata.nr_tz_sensor; i++) {
> >>> +		int temp =3D trec[cur_thermal_record].temp[i] /
> >>> 1000;
> >>> +		int y =3D 0;
> >>> +
> >>> +		y =3D i * NR_LINES_TZDATA + 2;
> >>> +		/* y at tz temp data line */
> >>> +		mvwprintw(thermal_data_window, y, 1,
> >>> "%6.6s%2d:[%3d][",
> >>> +			ptdata.tzi[i].type,
> >>> +			ptdata.tzi[i].instance, temp);
> >>> +		draw_hbar(thermal_data_window, y, TDATA_LEFT,
> >>> temp, ACS_RARROW,
> >>> +			true);
> >>> +		draw_tp_line(i, y);
> >>> +	}
> >>> +	wborder(thermal_data_window, 0, 0, 0, 0, 0, 0, 0, 0);
> >>> +	wrefresh(thermal_data_window);
> >>> +}
> >>> +
> >>> +const char tz_title[] =3D "THERMAL ZONES/SENSORS";
> >>> +
> >>> +void show_sensors_w(void)
> >>> +{
> >>> +	int i, j;
> >>> +	char buffer[512];
> >>> +
> >>> +	if (tui_disabled || !tz_sensor_window)
> >>> +		return;
> >>> +
> >>> +	werase(tz_sensor_window);
> >>> +
> >>> +	memset(buffer, 0, sizeof(buffer));
> >>> +	wattron(tz_sensor_window, A_BOLD);
> >>> +	mvwprintw(tz_sensor_window, 0, maxx/2 - sizeof(tz_title),
> >>> tz_title);
> >>> +	mvwprintw(tz_sensor_window, 1, 1, "Thermal Zones:");
> >>> +	wattroff(tz_sensor_window, A_BOLD);
> >>> +
> >>> +	mvwprintw(tz_sensor_window, 1, TZ_LEFT_ALIGN, "%s",
> >>> buffer);
> >>> +	/* fill trip points for each tzone */
> >>> +	wattron(tz_sensor_window, A_BOLD);
> >>> +	mvwprintw(tz_sensor_window, 2, 1, "Trip Points:");
> >>> +	wattroff(tz_sensor_window, A_BOLD);
> >>> +
> >>> +	/* draw trip point from low to high for each tz */
> >>> +	for (i =3D 0; i < ptdata.nr_tz_sensor; i++) {
> >>> +		int inst =3D ptdata.tzi[i].instance;
> >>> +
> >>> +		mvwprintw(tz_sensor_window, 1,
> >>> +			TZ_LEFT_ALIGN+TZONE_RECORD_SIZE * inst,
> >>> "%.9s%02d",
> >>> +			ptdata.tzi[i].type,
> >>> ptdata.tzi[i].instance);
> >>> +		for (j =3D ptdata.tzi[i].nr_trip_pts - 1; j >=3D 0;
> >>> j--) {
> >>> +			/* loop through all trip points */
> >>> +			char type;
> >>> +			int tp_pos;
> >>> +			/* reverse the order here since trips are
> >>> sorted
> >>> +			 * in ascending order in terms of
> >>> temperature.
> >>> +			 */
> >>> +			tp_pos =3D ptdata.tzi[i].nr_trip_pts - j -
> >>> 1; +
> >>> +			type =3D
> >>> trip_type_to_char(ptdata.tzi[i].tp[j].type);
> >>> +			mvwaddch(tz_sensor_window, 2,
> >>> +				inst * TZONE_RECORD_SIZE +
> >>> TZ_LEFT_ALIGN +
> >>> +				tp_pos,	type);
> >>> +			syslog(LOG_DEBUG, "draw tz %d tp %d
> >>> ch:%c\n",
> >>> +				inst, j, type);
> >>> +		}
> >>> +	}
> >>> +	wborder(tz_sensor_window, 0, 0, 0, 0, 0, 0, 0, 0);
> >>> +	wrefresh(tz_sensor_window);
> >>> +}
> >>> +
> >>> +void disable_tui(void)
> >>> +{
> >>> +	tui_disabled =3D 1;
> >>> +}
> >>>
> >>
> >>
> >=20
> > [Jacob Pan]
> >=20
> >=20
>=20
>=20

[Jacob Pan]

--MP_/yKBLsnwj0BUM2MJMYPxJTHF
Content-Type: image/png
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Screenshot from 2013-10-10 07:13:31.png"

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
tpXLWbBNxZfeiR5Z/hrJJyN/Be++PpUDaefRoVcmMTVWjddoOuQ8Bk55gSl/fQP/z/qQmLOI/0wt
IG7olQxMOSFLzAshhBBCCCGEEELUoGkauqyR1Xh6+hnc+QeHN96exnuvLMLR4mg98CLuuWo4zeo5
nUpCD87q9h4bVh315EJQfLQf1Rnf8hX/z959R0dRdnEc/25JbxB6ERDpShMERRSULiIoghSlSlEQ
ARURxNeKoKhIsSKgVMEKgiBdaiAQ6SW00EOAJCRL6u6+f2wCCQSyGxKSwO9zzp5Dljs75c48O3Pn
mWeJ83mQx+7xujYm+Qwrpkxh5cUrbwXNmUoQENBkOON73M31ym0ZMQbU4MWR3fCatoBfvw4myS2Q
Kk170rtzNfxUxxIRERERERGRW8BsMmHo/Fx7+7ff/cCOkGAeeOgRbFYrDxWuwYyt83N7+URERERE
RERE5A70Qp0ObDy3A6PJxJaNa6lRuy79+vbWYO8iIiIiIiIiIpL3mfSrhSIiIiIiIiIikh+YTCaM
GiNLRERERERERETyOrPJhNlkNmf4ny/U6XCLF0dERERERERERCRjJrNZjxaKiIiIiIiIiEjepzGy
REREREREREQkX9AYWSIiIiIiIiIiki+Y1SNLRERERERERETyAz1aKCIiIiIiIiIi+YKjkGVWIUtE
RERERERERPI2k1ljZImIiIiIiIiISD6QMkaWObeXQ0RERERERERE5IZMJrPGyBIRERERERERkbxP
g72LiIiIiIiIiEi+YDJpjCwREREREREREckHzOqRJSIiIiIiIiIi+YHj0UKzClkiIiIiIiIiIpK3
mczqkSUiIiIiIiIiIvlAymDv5txeDhERERERERERkRsymcwa7F1ERERERERERPI+DfYuIiIiIiIi
IiL5gkmFLBERERERERERyQ9UyBIRERERERERkXzBZDJhNJtVyBIRERERERERkbzNbFaPLBERERER
ERERyQdSHi005/ZyiIiIiIiIiIiI3JDJZMaY2wshIiIiIiIiIiLiDBWyREREREREREQkX1AhS0RE
RERERERE8gUVskREREREREREJF9QIUtERERERERERPIF536y0OhL6VqVKOxhSPe21RJFkmcBPE03
ntxuTcZuNGM0KE5xilOc4hSnOMUpTnGKU5ziFKc4p+OSE7AZPTBl0g0lz6+H4hQHGMwemK0JJNnT
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
7lcL3YpRysOI/13uObw4LkjYx6R7KzIpt5dDRERERERERERcl4V6k5OFrAIEuhvxLZKHClkiIiIi
IiIiIpJ/ZaHe5Fwh69J+dsYkU2hbbFYXTURERERERERE5Ios1Js0RpaIiIiIiIiIiOQLKmSJiIiI
iIiIiEi+oEKWiIiIiIiIiIjkCypkiYiIiIiIiIhIvqBCloiIiIiIiIiI5AsqZImIiIiIiIiISL6g
QpaIiIiIiIiIiOQLZudDTQRUqUWtC5cuv2O1RJHkWQBP042ntFuTsRvNGA2KU5ziFKc4xSkuz8Ul
J2AzemDK5PZWnl8PxSlOcYpTnOIUpzjF5ek4g9kDszWBJHvKG16VKeSWyURXcaGQZaDy+1OZlvat
40Gcuas+xTOd1g44s2CKU5ziFKc4xSnulsed20xY4XqUvdXzVZziFKc4xSlOcYpT3B0Wl/G0m12I
dq6QZfmPT+o9xlfm9AtlS4gj2c0L98zu4Nps2A3GzCt4ilOc4hSnOMUpLhfikrEbnLjTlufXQ3GK
U5ziFKc4xSlOcXk5DpMZozUZW/qJiQuPzWTCK5wrZNkTiDp+giinP1ZERERERERERCR7abB3ERER
ERERERHJF1TIEhERERERERGRfEGFLBERERERERERyRdUyBIRERERERERkXxBhSwREREREREREckX
VMgSEREREREREZF8QYUsERERERERERHJF1TIEhERERERERGRfEGFLBERERERERERyRdUyBIRERER
ERERkXxBhSwREREREREREckXVMgSEREREREREZF8QYUsERERERERERHJF1TIEhERERERERGRfEGF
LBERERERERERyRfMTkUZfSldqxKFPQzp3rZaokjyLICn6caT263J2I1mjAbFKU5xisvjcckJ2Iwe
mDIp8+f59VCc4hSnOMUpTnGKU5ziFKe4PBZnMHtgtiaQZE/7bjLRe3dxJMp644lTOFfI8r6XlxfN
pJX/Ve8fD+LMXfUpnukH2IFM1kZxilOc4vJC3LnNhBWuR9lbPV/FKU5xilOc4hSnOMUpTnGKu+3j
Mp52c8c69FsU41S0c4UsAKzsfKUdI1ZZLr9jS4gj2c0L98x6Lths2A3GzCt4ilOc4hSX63HJ2A1O
3HHI8+uhOMUpTnGKU5ziFKc4xSlOcXkrDpMZozUZW+rfXrV4fdWneGUyWVouFLLsxIWf5MQR5ypk
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
IZgPzWTmuuTizlBERERERESckP2NrDJB1L+/AgCN+n9Mo8v+mc6aVv+i3xrL+YeetXlm8gTaVrgU
0WzEaJoBCTPa82Tv7QXfHN7yG6M+OcPTo6bzavlcEjbP58M3hhNxNk/7x5pEZL92dD04gJ6v92Fk
N1/IOE30rwuZvP8Gb0dvJL+CxJHD8a/fY0zjkXQb/zUtzQC7+KhOe34s6Ew4Q+NiIy1yNF3bpzNw
WEc+WPAaZmsi0Usm0vPtyfz59zZGRuMuyd43k3f73sInH33EpBcB9vJJvbYsiHGt5o719Go+av4e
qRP78PrMx/HIOMm2qf0ZNiScpCJaget0MmP4be5WXmj9OC+2qYCPG9iSjxH1zcd88cG37EgtlfPU
REREREREJB/2N7Iyo5nSsA5TjMSmbWNYzToMs/ukedgyODJ7EC9MHXT9uJwEtn7+Ll0+f/caAdn8
NfI/hIy8/Nn0iIE84lsE+RmNA2wpu5n90pPMtiOtv+U7LgDZnFo2nj7LxudzMKNxF9jSODCtL89M
62s02xLKRtqehQwPXcjw4k7FWWSfYPXQPqweWtyJiIiIiIiISElSKn9ITkRERERERERESh41skRE
REREREREpEQwtrSwTDBVPc0EVPe4wekURCZ/vvd/hLxXhKf0aUDnCd2p7329IBuWzZMZOXGfwfwc
WEcB88t0wClFRERERERERAqlEP0mg42sspT3MONX0ZkaWcUgbQ+zXutV3Flcm7PnJ1IS2XLJtKSR
ld9vECjOueKMcvY6FGcfZ69DcfZx9joUZx9nr0Nx9nH2OhRnX5xIQRSi32T6Yd5sW/PHW7F50waa
/N+jWHNz+VeFhpdH+TXmk+j/EdT1frovTXFw1iIiIiIiIiIiUurk02/aeGYnZjc3Itat4b4HmhK2
bLH2yBIRERERERERkZJBjSwRERERERERESkR1MgSEREREREREZESQY0sEREREREREREpES40skzY
bLbizURERERE5P/Zu+/4mu4/juOvO7ITQWJTVRS1qlpao1WjqF1VRVujVUXtGjVK0dJarVG/qtKF
KlWjNGZVjKoRRa3YiRUiIbkZkpv7+yMJSSRcktxE+34+HvnDue97z/mez73XvZ97zveIiIiIpJHY
szIAOiJLREREREREREQeEGpkiYiIiIiIiIjIA8Fsf9SEd/nHefxq1M0lVks4ca55cTXd+Z42azw2
oxmjQTnllFNOOeWUU0455ZRTTrlcnYuPJcHogukuhz3k+nEop5xyuS5n+zoHUwAAIABJREFUMLtg
tsYSlzy7lVs5fJzucqc07qGRZaDc2HnMT7koaCcXS9Sk8F3ve+tcRuWUU0455ZRTTjnllFNOOeVy
ce7KX5zxrUFJR69XOeWU+w/k0r/vX/eQtq+RZdnHpzWe5wtz6o1KiI0m3skN57t16hMSsBmMd+/g
Kaeccsopp5xyyimnnHLKKZfDuXhsBjuOwMj141BOOeVyWw6TGaM1noTUdyb6UuRd7niLfY0sWyzh
QcGE2/2wIiIiIiIiIiIiWUuTvYuIiIiIiIiIyANBjSwREREREREREXkgqJElIiIiIiIiIiIPBDWy
RERERERERETkgaBGloiIiIiIiIiIPBDUyBIRERERERERkQeCGlkiIiIiIiIiIvJAUCNLRERERERE
REQeCGpkiYiIiIiIiIjIA0GNLBEREREREREReSCokSUiIiIiIiIiIg8ENbJEREREREREROSBoEaW
iIiIiIiIiIg8ENTIEhERERERERGRB4IaWSIiIiIiIiIi8kAw25UyelL88UfxdTGkWmy1hBPnmhdX
053vbrPGYzOaMRqUU0455ZRTTjnllFPuAcrFx5JgdMF0l59/c/04lFNOOeWUUy4X5AxmF8zWWOJs
KZfGc+3wQU6FW+985yT2NbLcK9Jr9Q80zZNmedBOLpaoSeG7PoANuMtolFNOOeWUU0455ZRTLrfl
rvzFGd8alHT0epVTTjnllFPuX5lL/75/vVKdHqsj7Erb18gCwMqBPq0Z/rvl5pKE2Gjindxwvtsv
VAkJ2AzGu3fwlFNOOeWUU0455ZRTLlfl4rEZ7PglOtePQznllFNOOeVyPofJjNEaT0Lyv90e573f
J+F2l7uldA+NLBvRl84RfMq+DpmIiIiIiIiIiEiGPIsSlWC7p0aWJnsXEREREREREZEHghpZIiIi
IiIiIiLyQFAjS0REREREREREHghqZImIiIiIiIiIyANBjSwREREREREREXkg2HfVQqf8FHA2kreQ
UzZvjoiIiIiIiIiI/CeYC1MrjxnvUvb3m+xrZJnzkt/JgJevGlkiIiIiIiIiIpIFnArgDVDC2e67
2NfIij7JUYsVn3+i7m/DREREREREREREUoo+wG/X4/HZYrH7LpojS0REREREREREHgiJjSxDDm+F
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
pwleMIPxn8xg76Xsvvuik44Dsq897FzsffP61dR94mmWL17gxETWm/voWr4XO7NzUFWW2Fu+3H4c
12RfIst5nJHIEhEREREREZH/tCwksv5LN+K7zzzEJyFHCD7xNf/zy+my3OBbfxwbzEdYOjLIzlfk
zuMQERERERERkdzHeYu9yz1i5crinrSo4Y0RsKXEEGbO6TLdEL99CK/U+AYTgDWOi1G3i8zdxyEi
IiIiIiIiuY99iSz3whT3NOJf0iODJxM5POAJag5wbsHuyKcKb3zblcredwqyYd41gRFjj9hZvhw4
jiyyxl4gNCSnS5Exa9wlzoRcsi82Fx+HiIiIiIiIiGSzO+abMmZnIisv+T2M+BW0f8PZKu5vpnXp
ldOlEBERERERERGRrMpCvsm+RFbcUQ7GpBC4N9eugC4iIiIiIiIiIq4kC/kmLfYuIiIiIiIiIiIu
QYksERERERERERFxCUpkiYiIiIiIiIiIS1AiS0REREREREREXIISWSIiIiIiIiIi4hKUyBIRERER
EREREZegRJaIiIiIiIiIiLgEN/tDTQQE1aBGRNz1RyzmSJK98uJluvMrbZYUbEY3jAbFKU5xilOc
4hSnOMUpLhfEpSRiNXpiyuRn3Vx/HIpTnOIUpzjFuVCcwc0TN0siybbUB7wrEeieyYtu4kAiy0Cl
IVOZlvah0B1cKFmbIpm+1gbYUzDFKU5xilOc4hSnOMUp7h7EXd7JqQKPUPpe71dxilOc4hSnuPs6
LuPX7nQg2r5ElnkfXz3yNN+7pS+UNTGeFHdvPDL7JctqxWYwZp7BU5ziFKc4xSlOcYpTnOLuSVwK
NoMdvzDn+uNQnOIUpzjFKc514jC5YbSkYE3/YuLDYjN54Q32JbJsiUSGniHS7s2KiIiIiIiIiIg4
lxZ7FxERERERERERl6BEloiIiIiIiIiIuAQlskRERERERERExCUokSUiIiIiIiIiIi5BiSwRERER
EREREXEJSmSJiIiIiIiIiIhLUCJLRERERERERERcghJZIiIiIiIiIiLiEpTIEhERERERERERl6BE
loiIiIiIiIiIuAQlskRERERERERExCUokSUiIiIiIiIiIi5BiSwREREREREREXEJSmSJiIiIiIiI
iIhLUCJLRERERERERERcgptdUUY/StR4gAKehnQPW8yRJHvlxct055fbLCnYjG4YDYpTnOIUpzjF
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
xBrGgqeDWJDT5fivUz3Lf4n6s/yXqD+LiIiIi7MvkeVemib+bvCgJ+SiqYW2qF2Ma9GEcTldkFwl
kcMDnqDmgJwuh4iIiD30uSUiIiJy33IvTHFPI/4O3ErZzkRWwav/L5Wb7zkuIiIiIiIiIiIuwz0v
+T2M+BV0diIrbjfLo1MIXJF7RmOJiIiIiIiIiIgLizvKwZgUAvfaf8cfYzYWR0RERERERERExGmU
yBIREREREREREZegRJaIiIiIiIiIiLgEJbJERERERERERMQlKJElIiIiIiIiIiIuQYksERERERER
ERFxCUpkiYiIiIiIiIiIS3CzP9REQFANakTEXX/EYo4k2SsvXqY7v9JmScFmdMNoUJziFHdLXEoi
VqMnpkzSyrn+OBSnOMUpTnGKU5ziFKc4xSlOcYq7A4ObJ26WRJJtqQ94VyLQPZMX3eR6Istms90p
DjBQachUpqV9KHQHF0rWpkimu7EB9hRMcYq7D+Mu7+RUgUcofa/3qzjFKU5xilOc4hSnOMUpTnGK
U9w9jcv4tTszi0iTs7JvRJZ5H1898jTfu6UvlDUxnhR3bzwyG0litWIzGDPP4ClOcfdlXAo2gx0Z
7lx/HIpTnOIUpzjFKU5xilOc4hSnOMXdgckNoyUFa/oXEx8Wm8kLb7AvkWVLJDL0DJF2b1ZERERE
RERERMS5tNi7iIiIiIiIiIi4BCWyRERERERERETEJSiRJSIiIiIiIiIiLkGJLBERERERERERcQlK
ZImIiIiIiIiIiEtQIktERERERERERFyCElkiIiIiIiIiIuISlMgSERERERERERGXoESWiIiIiIiI
iIi4BCWyRERERERERETEJSiRJSIiIiIiIiIiLkGJLBERERERERERcQlKZImIiIiIiIiIiEtQIktE
RERERERERFyCElkiIiIiIiIiIuISlMgSERERERERERGXoESWiIiIiIiIiIi4BCWyRERERERERETE
JRgBDDldChERERERERERkdu4lrvSiCwREREREREREXEJSmSJiIiIiIiIiIhLMKb5r4iIiIiIiIiI
SO5jTPc/ERERERERERGR3E2JLBERERERERERcQlKZImIiIiIiIiIiEtITWQZ7hwlIiIiIiIiIiKS
Y67mrjQiS0REREREREREXIISWSIiIiIiIiIi4hKUyBIREREREREREZegRJaIiIiIiIiIiLgEJbJE
RERERERERMQlKJElIiIiIiIiIiIuQYksERERERERERFxCUpkiYiIiIiIiIiIS1AiS0RERERERERE
XIISWSIiIiIiIiIi4hKUyBIREREREREREZegRJaIiIiIiIiIiLgEJbJERERERERERMQlKJElIiIi
IiIiIiIuQYksERERERERERFxCUpkiYiIiIiIiIiIS1AiS0REREREREREXIISWSIiIiIiIiIi4hKU
yBIREREREREREZegRJaIiIiIiIiIiLgEJbJERERERERERMQlKJElIiIiIiIiIiIuQYksERERERER
ERFxCUpkiYiIiIiIiIiIS1AiS0REREREREREXIISWSIiIiIiIiIi4hKUyBIREREREREREZegRJaI
iIiIiIiIiLgEJbJERERERERERMQlKJElIiIiIiIiIiIuQYksERERERERERFxCUpkiYiIiIiIiIiI
S1AiS0REREREREREXIISWSIiIiIiIiIi4hKUyBIREREREREREZegRJaIiIiIiIiIiLgEJbJERERE
RERERMQluN3uiWBzyL0sh9wnavpWtCtO/U8cYW+/EhEREREREdemEVkiIiIiIiIiIuISlMgSERER
ERERERGX4LxEliWSg5M+pmv1WtTyrUjNAnV4vvlg5h+Kx5YuMInTc8bz/cTdRFruYn8pZ5lTpyI1
fa/9e4UN0Xd3CLmfhaitPzLgsTr8n29Fauavy6tv/czBSOvdbfZaXTZcRpTtdkFOajenimXrC1XT
9IGM/tWg/8a4dK+KWdWDer4VqVmsLztjb9qkLZxl9W/dxnMN+zN7WyR3WdN3KWvH63R29RcRERER
ERER57vtGlkOsUaxo19b3p54jvIvdKH/gAp4Rx9n928LWb6nOy0f9MZwPTiJ079+x+QTBpq++T/y
mrJa8iI8N28D9RKSOP9TF7qMdMqR5GrJIT/Tq8kI/irfkh4TniD/+fVMHfI5b51x54/F7SnhnsUN
G9wJKFeO8t55MBpuF+SkdnMqbyr1/YYRbZOuJksT/mZqtymEPNSZT/s+iBeAwYviVTzTvCaOo7/t
IA53iNrCioPxPFLH+9ZN+9Sh5/evUtbTSsKlo2wcN56vGh3DFjybl8s7523juKwcbzawq7+IiIiI
iIiIOJ9TrsgT9ozl04mnKNH7N6Z/URPf1Ivb5zq/jTnOlE3zF034Fi2OLykQ6JEte8hd4jg48nsO
pFTjw3lf8lIZE9CUh73/peWAccwIbsWARzJIyNjDVIjGM1fS2KnlvRdMBD76LI0eTf0zJg9Le0/h
VKk6NHzhcXwzekncUVaujSJfuz5UW/ktWxf8S2Kdh7gl9eNTilrNGlLdB6AR9WvGsO/xn1i46gIv
ditBzuTxsnC82VIMV+0vIiIiIiIi4uqckGOK4+9JCwmjOm/2qHY9iQWAwQNf39RL/piN9MxXkZq+
Nem5KgVCRtM637XpUG2Yfy79fLWkA1/R1LcafRfuYf47L9E4sCI1fYN46tHB7M7OKYQp4ez9rj+d
qtTgYd+K1CxYl5deGsW60JRs3KkdEk6wYUMkVGnOYyWupVHcKNakGWW4xNYVp0kCIJkTI56lZr7O
bIm58fL4rf15yvdRhu6Iv/Fg9Bo6p52WltFUMQfbLbdL+mclf170otoLzWhay42wZWs5nZj56wzu
XrgB1mQLrjGbzt5+cC2uI7/P+pK3q1ajpm9Faj/YiclbotJPpbSnvziyPVscIdP606FMEDV9g3im
/mDmTXqd2r4NmXQkORvqRERERERERFzd3SeyksM4sCcKSj1C5cA7jFPxq81n+9ez+K/FfPqYCUq/
yYR961j81zoWH/qBRoUzem08ewf0Yk5KMwatXs78rT/Sq0lBjLZsSiVYo9jx/vN0+nAl1kZ9+Wrh
z0z4sRePmXaxPiQhe/Zpr4RzHD0PHqXLkS/NODq3QhUpYoKw/Rdw+NLfrx4jDq1j8f7ZdH3gdjFZ
abfcKpnQZWu5wIPUr1mch1pUguMr+fN0BklKWzIJ5jjiYmOI+Hc7c4fM5ixBNHq2qJPm4+YySVsZ
N8XIS7+vZe2BH+kQ8CffdxzD32mX27Knv9i9PStXlg+k8zt/EPnU+3y9aBLvNTjDhA+3pCZkRURE
RERERG5199fkyVGcjwQKFcH/TlszeJG/VAnyE8tJHwN4BFCkdElKZDIr0FzqXb4d35YiJoAKlKle
766LfDvJx37l68lnKfHefCYMqXp1zSHq8GiLdqRYcjZhY42PwmwB77ze6bOPJm/yeENyZAxJNtKP
iMuM0ZvA0iUhxUg+r9vEZLHdcqXkc2ydfxIqtaVaAXcC6z1FCcazel0Yr1Usnn66YPg83i4z78bf
nkG8+NtU3ghyxQO3RzFafdOLp4I8gQJ0HFCXGe3/ZHtoMg9VSl18zZ7+Yu/2Us6zZsQSosq8zQ8T
36KSF1C/Gj5/P0Wfhdl6oCIi6jJOjwAAB8BJREFUIiIiIuLCsmf5Kid68LUnKeSMHJIlAXNUFNGR
V//FxCTedAc6K1E713CM0jR96QHSX6ebcMtqGTLdr4Nul6iyWV1kylvOsV7YyopDULB+HYq6g0fZ
x/lfIByZu4OImxvF70k+XDiTKSt+Zvwvg3m1zgXmdOjKj8FxWatnZ/cDZzOWoWbZayuFGfAILIQv
sVyKyuKU2sy2l3CcrYcg75NPUfram80QQNUWmQ31EhERERERkfvZ3Sey3AIoEgBEXSDa6ctIeZG/
kI9Tsm0Ju7+gRbH/8WTxq/+eePhrjsSnjbBiDosF/CmS13mTxzLfr32M3gH4miD+Snz6BIglnpgE
cPP3x0N3kLsDKxF/LuII3jxUvziGhESSDKV4rJYHtt0L2Rt+U3rKqwiV6z5CrcfrULd1B/rO+Z42
eQ/yw4BVhGchA+WsfpBt3DxwT/tGMxgAK9asZkcz215SLNHx4FvIN83724BX3jz/zambIiIiIiIi
4hR3f83oUZhqD/vDr7s4HG4hqLgzp+AZMGaaxbIve+NRpTNjVjYnMfVC2uBTjDLpblVnxLewHxDB
+cgUKOacKWSZ79dOXsWoVBR2nj5JZMoT+Ka2XMrFfwlLgUIPFeZaiQ0mA2BLN3LIlpKIay3L7mS2
KPbN3o+VZNa1e5Ta6Z7cy/Jd0TzbNOD2vcmnNNVKw7yQA1xIbEUBB28Q6bR+4IBc3Q88/PD3hhOX
zGkSszYSImPI4dsqiIiIiIiISC7mhMEPPlR5qxmBv85m6vcHeXZojRvrNFkTiI5zx98vbXLLgJu3
OySZSXTK3CoDnnm9gDgiYizgn3EizehXiqqPlbrDdowEPNKQCnzNsplHeOOLatzIVVhItphwz0KO
LvP92smrLE8+mZcZsxaz7VwH2pYyASn/396dxzZZx3Ecf7drS2GMMWAdZ8YuWBAXBgNCJyQIUQ5F
UXAJZm4e4FAnyCFHEASGHBEY2xgkkxAIEhiHIk4MEBTUDKILh0CWjcNAOAwTImNbM9bWP9igYHCH
ZWXh8/qraZ7nybfP8+0/n/x+34ere/dwniBefj60Osjyw799S6i8QcktFwQYgSr+OlbErf9VgLef
WyO7eZzvDt/GGDeNjMVxd3vUdeNnlozNoiD3FOUj7Pg/7HzHFQovAa1stGzAv8ZrfVBnj6oPvMQa
TnwP+PHgIS44+tDNCrhvcmp3ERDs6+pERERERETkMeWVXTzN+0/m0+SDpKaPI/lyCgnDImhReo7D
G3O5NH4HOYk2j+1DzehsD4VdX7FhUzyJdhvNTM2xhXdqUEAARlr3HUxXVrFuQS4hid3wt7SkS6/u
tK3noipzRALT3tlMSvobpJRNZtyIKAIqLlKweRtXJ2xg0ZCWDSnQS1oQM/1dem5ZypIxc6iYMoig
ywdYN+8Uxr6zSO7Xovo4I637DSGclWxYdZC4Gb3xO7mNpSuLgTYe13NTWXKFa6VO3M4/ueEA/Eq4
/MdFSjFgbh2CLcjssULJ28+tcZUd281vZQZixo9mgN2jH6va82psFksOfEtRmZ3YmttYfoGCvH1c
b+ai8u9LnNiaw5YrJnpNHU5ns49+RL3UtQ/qqr79UgtTB4bMfIGssdlMfb8N05K7cTt/Ayv2l6Eg
S0RERERERB7GOxGEsQ3PrNrJuqeWk529ns9yb+E2BxJqH0lSXMADM65MdEpazLQjM8n5KIk9LoCn
mVu8jdEdG7Yt0Rz9FktXnmX23Ll8sAmgB7MLdzK2Sz2vZwyk//IdfBG5jNVr05mZUwbWYKKGjmFi
91pf0/bImaPeJCPPzZKPc0h/e/udLVkdE8jcnkSoR2hn7pZE2rLTzJ4/gRczzYTEJzB+/khOTsz3
uFo5RycNI+Vrz0FNCxnXcyEAwRN3sPvzGO7tfvP+c2s8FZzZ/gul9GTEoLb396MpBPtr3WHWIfYX
OojtXf19eT6ZyTX3y0xQdH8SsqbwXlJok5nhVLc+qKv69kttjAQNX0ROhoV58xcxeYuRtgNeJ3WR
nbRJ17CaNPBNRERERERE/s2wY+uX7pEvvcJPP+xn0LPP4XI6GdAuhqNlxb6uTf6Lu4Iza1JImv4r
YTM2snpOHIGP/TsoIdY/qk7Hqf+eRFVcXDWKUWldyTqbTXyrup9Z174SERERERGRpiO/5ARGPz8O
HdjLwMFDydu1s8ksLpEHGZoTOXEN66pmsvbqdcpvQ+AjHh4u4k2uG4dZv+J3Qgb2IbKDhdKTeWSn
FdM+cQG9AnxdnYiIiIiIiDyOFGQ1ZYYWRH+YQbqv6xBpAIPRj/LjO1m5ZhnXK8AQGMaACZnkfHJv
GL+IiIiIiIiIJwVZIuIThsC+pH6zh1RfFyIiIiIiIiJNxv1Bltt996Nmzogvqf9ERERERERExDOr
Ao8gy2yx4HA4sFqt5JecaPS6REREREREREREahiNRhyOCiwWy93v7gRZbgi2hVBceJqo6B5YrVYw
aEiNiIiIiIiIiIj4gNuNw1FBUeFp2tlCoHphlgnA6XISFh7B+XNnOVZwhMrKSl+WKiIiIiIiIiIi
TziLxUI7Wwhh4RE4XU6gJsiqqsLPZCIisjuRUdE+LVJERERERERERATA7XbjdDlxVlUB1UHWvu/z
fFqUiIiIiIiIiIhIbf4BBwYpdqRkFyMAAAAASUVORK5CYII=

--MP_/yKBLsnwj0BUM2MJMYPxJTHF--
